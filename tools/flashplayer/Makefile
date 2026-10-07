# Run in tools/flashplayer from an x86 Visual Studio Developer Command Prompt:
#   nmake /nologo
# launch.ps1 also configures that environment automatically.
OUTDIR = ..\..\bin\flashplayer
CXX = cl
CXXFLAGS = /nologo /O2 /MT /EHsc /std:c++17 /W4 /WX /DNOMINMAX /DWIN32_LEAN_AND_MEAN
LDFLAGS = /NOLOGO /MACHINE:X86

all: "$(OUTDIR)\bymr-input.dll" "$(OUTDIR)\bymr-player.exe"

"$(OUTDIR)\input_fix.obj": input_fix.cpp input_fix.h player_imports.h Makefile
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"
	$(CXX) $(CXXFLAGS) /c input_fix.cpp /Fo$@

"$(OUTDIR)\player_imports.obj": player_imports.cpp player_imports.h Makefile
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"
	$(CXX) $(CXXFLAGS) /c player_imports.cpp /Fo$@

"$(OUTDIR)\launch.obj": launch.cpp input_fix.h Makefile
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"
	$(CXX) $(CXXFLAGS) /c launch.cpp /Fo$@

"$(OUTDIR)\bymr-input.dll": "$(OUTDIR)\input_fix.obj" "$(OUTDIR)\player_imports.obj"
	link $(LDFLAGS) /DLL /OUT:$@ /IMPLIB:"$(OUTDIR)\input_fix.lib" "$(OUTDIR)\input_fix.obj" "$(OUTDIR)\player_imports.obj" user32.lib

"$(OUTDIR)\bymr-player.exe": "$(OUTDIR)\launch.obj"
	link $(LDFLAGS) /SUBSYSTEM:CONSOLE /OUT:$@ "$(OUTDIR)\launch.obj" user32.lib

clean:
	-del /q "$(OUTDIR)\input_fix.obj" "$(OUTDIR)\player_imports.obj" "$(OUTDIR)\launch.obj"
	-del /q "$(OUTDIR)\bymr-input.dll" "$(OUTDIR)\input_fix.lib" "$(OUTDIR)\input_fix.exp" "$(OUTDIR)\bymr-player.exe"
