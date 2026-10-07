<#
.SYNOPSIS
Build and launch the local SWF with the Windows Flash Player input scheduling fix.
.DESCRIPTION
Requires Visual Studio C++ Build Tools and a Windows SDK. NMake builds the x86
launcher and DLL incrementally into bin/flashplayer. The fix requires Windows 10
version 1803 or later.

Use -BuildOnly to build without launching. To invoke NMake directly, open an x86
Developer Command Prompt, change to tools/flashplayer, and run "nmake /nologo".
.EXAMPLE
powershell -NoProfile -ExecutionPolicy Bypass -File tools/flashplayer/launch.ps1 -Swf bin/bymr-local.swf
#>
[CmdletBinding()]
param(
    [string]$Swf,
    [string]$Player,
    [switch]$BuildOnly
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path

function Build-Launcher {
    $programFiles = [Environment]::GetFolderPath('ProgramFilesX86')
    $vswhere = Join-Path $programFiles 'Microsoft Visual Studio/Installer/vswhere.exe'
    if (!(Test-Path -LiteralPath $vswhere)) {
        throw 'Building the Flash input fix requires Visual Studio C++ Build Tools.'
    }

    $installation = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if ($LASTEXITCODE -ne 0 -or !$installation) {
        throw 'Install the Desktop development with C++ workload to build the Flash input fix.'
    }

    # Configure the toolchain in a child shell. Visual Studio selects its SDK;
    # the caller's PATH, INCLUDE and LIB environment remain unchanged.
    $previousDevCommand = $env:BYMR_VS_DEV_CMD
    $env:BYMR_VS_DEV_CMD = Join-Path $installation 'Common7/Tools/VsDevCmd.bat'
    Push-Location -LiteralPath $PSScriptRoot
    try {
        & $env:ComSpec /d /c 'call "%BYMR_VS_DEV_CMD%" -no_logo -arch=x86 -host_arch=x64 && nmake /nologo /f Makefile'
        if ($LASTEXITCODE -ne 0) {
            throw "Building the Flash input fix failed (exit code $LASTEXITCODE)."
        }
    } finally {
        Pop-Location
        $env:BYMR_VS_DEV_CMD = $previousDevCommand
    }
}

if (!$BuildOnly) {
    if (!$Swf) {
        throw 'Specify the SWF to launch with -Swf.'
    }
    if (!$Player) {
        $Player = Join-Path $repoRoot 'client/archived/flashplayers/flashplayer.exe'
    }
    $Player = (Resolve-Path -LiteralPath $Player).Path
    $Swf = (Resolve-Path -LiteralPath $Swf).Path
}

Build-Launcher

if (!$BuildOnly) {
    $launcher = Join-Path $repoRoot 'bin/flashplayer/bymr-player.exe'
    & $launcher $Player $Swf
    exit $LASTEXITCODE
}
