#pragma once

// Locate a function pointer in the running player's USER32 imports, including
// delay-loaded imports. The returned slot belongs to the executable in memory.
void** findPlayerImport(const char* functionName);

bool replacePlayerImport(void** slot, void* replacement);
