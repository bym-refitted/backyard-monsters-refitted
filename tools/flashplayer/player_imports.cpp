#include "player_imports.h"

#include <windows.h>
#include <delayimp.h>
#include <cstring>

namespace {

void** findFunction(BYTE* image, DWORD namesRva, DWORD slotsRva, const char* functionName) {
    if (!namesRva || !slotsRva) {
        return nullptr;
    }

    auto names = reinterpret_cast<IMAGE_THUNK_DATA*>(image + namesRva);
    auto slots = reinterpret_cast<IMAGE_THUNK_DATA*>(image + slotsRva);
    for (; names->u1.AddressOfData; ++names, ++slots) {
        if (IMAGE_SNAP_BY_ORDINAL(names->u1.Ordinal)) {
            continue;
        }

        auto entry = reinterpret_cast<IMAGE_IMPORT_BY_NAME*>(image + names->u1.AddressOfData);
        if (strcmp(reinterpret_cast<const char*>(entry->Name), functionName) == 0) {
            return reinterpret_cast<void**>(&slots->u1.Function);
        }
    }
    return nullptr;
}

} // namespace

void** findPlayerImport(const char* functionName) {
    auto image = reinterpret_cast<BYTE*>(GetModuleHandleW(nullptr));
    auto dosHeader = reinterpret_cast<IMAGE_DOS_HEADER*>(image);
    auto headers = reinterpret_cast<IMAGE_NT_HEADERS*>(image + dosHeader->e_lfanew);
    const auto& directories = headers->OptionalHeader.DataDirectory;

    DWORD importsRva = directories[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
    if (importsRva) {
        auto library = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(image + importsRva);
        for (; library->Name; ++library) {
            if (_stricmp(reinterpret_cast<const char*>(image + library->Name), "USER32.dll") != 0) {
                continue;
            }
            if (auto slot = findFunction(image, library->OriginalFirstThunk, library->FirstThunk, functionName)) {
                return slot;
            }
        }
    }

    // The standalone Flash Player uses this delay-loaded import table.
    DWORD delayImportsRva = directories[IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT].VirtualAddress;
    if (delayImportsRva) {
        auto library = reinterpret_cast<ImgDelayDescr*>(image + delayImportsRva);
        for (; library->rvaDLLName; ++library) {
            if (!(library->grAttrs & dlattrRva) ||
                _stricmp(reinterpret_cast<const char*>(image + library->rvaDLLName), "USER32.dll") != 0) {
                continue;
            }
            if (auto slot = findFunction(image, library->rvaINT, library->rvaIAT, functionName)) {
                return slot;
            }
        }
    }
    return nullptr;
}

bool replacePlayerImport(void** slot, void* replacement) {
    DWORD originalProtection;
    if (!VirtualProtect(slot, sizeof(void*), PAGE_READWRITE, &originalProtection)) {
        return false;
    }

    InterlockedExchangePointer(slot, replacement);
    DWORD ignored;
    VirtualProtect(slot, sizeof(void*), originalProtection, &ignored);
    return true;
}
