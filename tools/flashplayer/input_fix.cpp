#include "input_fix.h"
#include "player_imports.h"

namespace {

constexpr UINT_PTR kInputTimerId = 1;
constexpr wchar_t kSchedulerWindowClass[] = L"Messaging";
constexpr LONGLONG kWakeDelay = -10000; // Relative one millisecond, in 100 ns units.

using SetTimerFunction = UINT_PTR(WINAPI*)(HWND, UINT_PTR, UINT, TIMERPROC);
using KillTimerFunction = BOOL(WINAPI*)(HWND, UINT_PTR);

SetTimerFunction originalSetTimer = nullptr;
KillTimerFunction originalKillTimer = nullptr;
InputFixStatus* status = nullptr;

// The hook runs on the player's UI thread; the helper thread only posts a wake.
// All access to window and armed is protected by lock.
struct PendingWake {
    HANDLE timer = nullptr;
    SRWLOCK lock = SRWLOCK_INIT;
    HWND window = nullptr;
    bool armed = false;
} wake;

class ExclusiveLock {
public:
    explicit ExclusiveLock(SRWLOCK& lock) : lock_(lock) {
        AcquireSRWLockExclusive(&lock_);
    }
    ~ExclusiveLock() {
        ReleaseSRWLockExclusive(&lock_);
    }
    ExclusiveLock(const ExclusiveLock&) = delete;
    ExclusiveLock& operator=(const ExclusiveLock&) = delete;

private:
    SRWLOCK& lock_;
};

DWORD WINAPI deliverWake(void *) {
    while (WaitForSingleObject(wake.timer, INFINITE) == WAIT_OBJECT_0) {
        ExclusiveLock lock(wake.lock);

        if (wake.armed) {
            wake.armed = false;
            // The player handles the notification on its normal UI thread.
            // No rendering or game updates run on this helper thread.
            PostMessageW(wake.window, WM_TIMER, kInputTimerId, 0);
        }
    }

    return 0;
}

void cancelPendingWake(HWND window, UINT_PTR id) {
    ExclusiveLock lock(wake.lock);

    if (window == wake.window && id == kInputTimerId) {
        wake.armed = false;
        CancelWaitableTimer(wake.timer);
    }
}

bool isInputDeferral(HWND window, UINT_PTR id, UINT delay, TIMERPROC callback) {
    if (!window || id != kInputTimerId || delay != 0 || callback ||
        GetCurrentThreadId() != status->threadId) {
        return false;
    }

    wchar_t className[64];
    return GetClassNameW(window, className, 64) && wcscmp(className, kSchedulerWindowClass) == 0;
}

UINT_PTR WINAPI setTimer(HWND window, UINT_PTR id, UINT delay, TIMERPROC callback) {
    if (!isInputDeferral(window, id, delay, callback)) {
        cancelPendingWake(window, id);
        return originalSetTimer(window, id, delay, callback);
    }

    // Keep the original timer as a fallback if the extra wake cannot be delivered.
    UINT_PTR timerId = originalSetTimer(window, id, delay, callback);
    if (!timerId) {
        return 0;
    }

    // SetTimer(0) is clamped to >=10 ms. Give the player a brief input yield
    // using a high-resolution timer, then deliver its existing notification.
    ExclusiveLock lock(wake.lock);
    LARGE_INTEGER due;
    due.QuadPart = kWakeDelay;
    wake.window = window;
    wake.armed = SetWaitableTimer(wake.timer, &due, 0, nullptr, nullptr, FALSE) != FALSE;
    if (wake.armed) {
        InterlockedIncrement(&status->correctedTimers);
    }

    return timerId;
}

BOOL WINAPI killTimer(HWND window, UINT_PTR id) {
    cancelPendingWake(window, id);
    return originalKillTimer(window, id);
}

DWORD installTimerHooks() {
    void **setTimerSlot = findPlayerImport("SetTimer");
    void **killTimerSlot = findPlayerImport("KillTimer");
    HMODULE user32 = GetModuleHandleW(L"USER32.dll");
    if (!setTimerSlot || !killTimerSlot || !user32) {
        return ERROR_NOT_SUPPORTED;
    }

    originalSetTimer = reinterpret_cast<SetTimerFunction>(GetProcAddress(user32, "SetTimer"));
    originalKillTimer = reinterpret_cast<KillTimerFunction>(GetProcAddress(user32, "KillTimer"));
    if (!originalSetTimer || !originalKillTimer) {
        return ERROR_PROC_NOT_FOUND;
    }

    wake.timer = CreateWaitableTimerExW(nullptr, nullptr, CREATE_WAITABLE_TIMER_HIGH_RESOLUTION, TIMER_ALL_ACCESS);
    if (!wake.timer) {
        return GetLastError();
    }

    // The temporary message hook is removed after initialization. Keep this DLL
    // loaded for the lifetime of the import pointers and sleeping helper thread.
    HMODULE pinnedModule;
    if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
                           reinterpret_cast<LPCWSTR>(&installTimerHooks), &pinnedModule)) {
        return GetLastError();
    }

    HANDLE thread = CreateThread(nullptr, 0, deliverWake, nullptr, 0, nullptr);
    if (!thread) {
        return GetLastError();
    }

    CloseHandle(thread);

    if (!replacePlayerImport(setTimerSlot, reinterpret_cast<void*>(setTimer))) {
        return GetLastError();
    }

    if (!replacePlayerImport(killTimerSlot, reinterpret_cast<void*>(killTimer))) {
        DWORD error = GetLastError();
        replacePlayerImport(setTimerSlot, reinterpret_cast<void*>(originalSetTimer));
        return error;
    }

    return ERROR_SUCCESS;
}

void initializeFromLauncher() {
    wchar_t mappingName[80];
    inputFixMappingName(mappingName, GetCurrentProcessId());

    HANDLE mapping = OpenFileMappingW(FILE_MAP_ALL_ACCESS, FALSE, mappingName);
    if (!mapping) {
        return;
    }

    status = static_cast<InputFixStatus*>(MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, sizeof(InputFixStatus)));
    CloseHandle(mapping);

    if (!status || status->processId != GetCurrentProcessId() || status->threadId != GetCurrentThreadId()) {
        return;
    }

    status->error = installTimerHooks();
    InterlockedExchange(&status->initialized, status->error ? kInputFixFailed : kInputFixReady);
}

} // namespace

extern "C" __declspec(dllexport) LRESULT CALLBACK BymrInputHook(int code, WPARAM removed, LPARAM message) {
    static bool initializationAttempted = false;
    
    if (code >= 0 && !initializationAttempted) {
        initializationAttempted = true;
        initializeFromLauncher();
    }

    return CallNextHookEx(nullptr, code, removed, message);
}
