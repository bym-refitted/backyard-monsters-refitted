#include "input_fix.h"

#include <cstdio>
#include <string>

namespace {

constexpr DWORD kStartupTimeoutMs = 15000;

struct Handle {
    explicit Handle(HANDLE handle) : value(handle) {}
    ~Handle() {
        if (value) {
            CloseHandle(value);
        }
    }
    Handle(const Handle&) = delete;
    Handle& operator=(const Handle&) = delete;

    HANDLE value;
};

struct StatusMapping {
    // Keep the named mapping handle open until the child has opened it too.
    Handle mapping{nullptr};
    InputFixStatus* value = nullptr;

    ~StatusMapping() {
        if (value) {
            UnmapViewOfFile(value);
        }
    }

    StatusMapping() = default;
    StatusMapping(const StatusMapping&) = delete;
    StatusMapping& operator=(const StatusMapping&) = delete;

    DWORD create(DWORD processId, DWORD threadId) {
        wchar_t name[80];
        inputFixMappingName(name, processId);
        mapping.value = CreateFileMappingW(INVALID_HANDLE_VALUE, nullptr, PAGE_READWRITE,
                                          0, sizeof(InputFixStatus), name);
        if (!mapping.value) {
            return GetLastError();
        }

        value = static_cast<InputFixStatus*>(
            MapViewOfFile(mapping.value, FILE_MAP_ALL_ACCESS, 0, 0, sizeof(InputFixStatus)));
        if (!value) {
            return GetLastError();
        }

        value->processId = processId;
        value->threadId = threadId;
        value->initialized = kInputFixPending;
        value->error = ERROR_SUCCESS;
        value->correctedTimers = 0;

        return ERROR_SUCCESS;
    }
};

std::wstring quoteArgument(const wchar_t* value) {
    // Windows argv quoting must also escape backslashes before quotes and at
    // the end of an argument. Quoting paths alone is insufficient.
    std::wstring result = L"\"";
    size_t backslashes = 0;

    for (const wchar_t* next = value; *next; ++next) {
        if (*next == L'\\') {
            ++backslashes;
            continue;
        }
        result.append(*next == L'"' ? backslashes * 2 + 1 : backslashes, L'\\');
        result += *next;
        backslashes = 0;
    }

    result.append(backslashes * 2, L'\\');
    return result + L'"';
}

int fail(const wchar_t* action, DWORD error = GetLastError()) {
    fwprintf(stderr, L"Flash Player launch failed: %ls (Windows error %lu).\n", action, error);
    return 1;
}

HMODULE loadInputFix() {
    wchar_t executable[32768];
    DWORD length = GetModuleFileNameW(nullptr, executable, ARRAYSIZE(executable));
    if (!length) {
        return nullptr;
    }

    if (length == ARRAYSIZE(executable)) {
        SetLastError(ERROR_INSUFFICIENT_BUFFER);
        return nullptr;
    }

    std::wstring libraryPath(executable, length);
    libraryPath = libraryPath.substr(0, libraryPath.find_last_of(L"\\/") + 1) + L"bymr-input.dll";
    return LoadLibraryExW(libraryPath.c_str(), nullptr,
                          LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR | LOAD_LIBRARY_SEARCH_SYSTEM32);
}

DWORD installInputFix(const PROCESS_INFORMATION& child, HMODULE library,
                      HOOKPROC hookFunction, InputFixStatus& status) {
    // A thread-specific hook needs the child's message queue to exist first.
    if (WaitForInputIdle(child.hProcess, kStartupTimeoutMs) != WAIT_OBJECT_0) {
        return ERROR_TIMEOUT;
    }

    HHOOK hook = SetWindowsHookExW(WH_GETMESSAGE, hookFunction, library, child.dwThreadId);
    if (!hook) {
        return GetLastError();
    }

    ULONGLONG deadline = GetTickCount64() + kStartupTimeoutMs;
    while (status.initialized == kInputFixPending && GetTickCount64() < deadline &&
           WaitForSingleObject(child.hProcess, 10) == WAIT_TIMEOUT) {
        PostThreadMessageW(child.dwThreadId, WM_NULL, 0, 0);
    }

    UnhookWindowsHookEx(hook);

    if (status.initialized == kInputFixReady) {
        return ERROR_SUCCESS;
    }

    return status.error ? status.error : ERROR_TIMEOUT;
}

int runPlayer(const wchar_t* player, const wchar_t* swf, HMODULE library, HOOKPROC hookFunction) {
    // The job owns only this launcher's child. Exiting on any startup error or
    // stopping the VS Code task closes that child, including while suspended.
    Handle job(CreateJobObjectW(nullptr, nullptr));
    JOBOBJECT_EXTENDED_LIMIT_INFORMATION limits = {};
    limits.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    if (!job.value ||
        !SetInformationJobObject(job.value, JobObjectExtendedLimitInformation, &limits, sizeof(limits))) {
        return fail(L"creating the player job");
    }

    STARTUPINFOW startup = {};
    startup.cb = sizeof(startup);
    PROCESS_INFORMATION child = {};
    std::wstring command = quoteArgument(player) + L" " + quoteArgument(swf);
    if (!CreateProcessW(player, command.data(), nullptr, nullptr, FALSE, CREATE_SUSPENDED,
                        nullptr, nullptr, &startup, &child)) {
        return fail(L"starting Flash Player");
    }

    Handle process(child.hProcess);
    Handle thread(child.hThread);
    if (!AssignProcessToJobObject(job.value, process.value)) {
        DWORD error = GetLastError();
        TerminateProcess(process.value, 1); // Our child is still suspended.
        return fail(L"assigning the player job", error);
    }

    StatusMapping status;
    DWORD error = status.create(child.dwProcessId, child.dwThreadId);
    if (error) {
        return fail(L"creating input fix status", error);
    }

    if (ResumeThread(thread.value) == static_cast<DWORD>(-1)) {
        return fail(L"resuming Flash Player");
    }

    error = installInputFix(child, library, hookFunction, *status.value);
    if (error) {
        return fail(L"initializing the input fix", error);
    }

    printf("Flash Player PID %lu: input scheduling fix active.\n", child.dwProcessId);
    fflush(stdout);
    if (WaitForSingleObject(process.value, INFINITE) != WAIT_OBJECT_0) {
        return fail(L"waiting for Flash Player");
    }

    DWORD exitCode;
    if (!GetExitCodeProcess(process.value, &exitCode)) {
        return fail(L"reading the player exit code");
    }
    
    return static_cast<int>(exitCode);
}

} // namespace

int wmain(int argc, wchar_t** argv) {
    if (argc != 3) {
        fwprintf(stderr, L"Usage: bymr-player.exe <flashplayer.exe> <game.swf>\n");
        return 2;
    }

    DWORD binaryType;
    if (!GetBinaryTypeW(argv[1], &binaryType) || binaryType != SCS_32BIT_BINARY) {
        return fail(L"a 32-bit Windows Flash Player is required", ERROR_NOT_SUPPORTED);
    }

    HMODULE library = loadInputFix();
    if (!library) {
        return fail(L"loading bymr-input.dll beside the launcher");
    }
    auto hookFunction = reinterpret_cast<HOOKPROC>(GetProcAddress(library, "_BymrInputHook@12"));
    int result;
    if (hookFunction) {
        result = runPlayer(argv[1], argv[2], library, hookFunction);
    } else {
        result = fail(L"finding the input fix entry point");
    }
    FreeLibrary(library);
    return result;
}
