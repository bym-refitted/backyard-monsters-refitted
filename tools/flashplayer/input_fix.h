#pragma once

#include <windows.h>
#include <cwchar>

constexpr LONG kInputFixPending = 0;
constexpr LONG kInputFixReady = 1;
constexpr LONG kInputFixFailed = -1;

// This mapping exists only between the launcher and the player it creates.
struct InputFixStatus {
    DWORD processId;
    DWORD threadId;
    volatile LONG initialized;
    DWORD error;
    volatile LONG correctedTimers;
};

inline void inputFixMappingName(wchar_t (&name)[80], DWORD processId) {
    swprintf_s(name, L"Local\\BYMRFlashInput-%lu", processId);
}
