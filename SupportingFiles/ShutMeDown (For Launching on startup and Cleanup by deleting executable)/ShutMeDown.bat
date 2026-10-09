@echo off
setlocal EnableExtensions DisableDelayedExpansion

REM Advanced BAT to EXE Converter exposes the compiled EXE through %%0.
set "ShutMeDownSelf=%~f0"
set "ShutMeDownFolder=C:\ChangeComputerName"

REM Wait for this GUI instance instead of polling all processes by name.
if not exist "%ShutMeDownFolder%\ChangeComputerName.exe" exit /b 1
start "" /wait "%ShutMeDownFolder%\ChangeComputerName.exe"

REM Leave the deployment folder so the launcher and helper do not hold it open.
cd /d "%SystemRoot%" || exit /b 1

REM The helper inherits the paths as data and retries while this EXE exits.
REM Do not add /wait here: the launcher must exit to release its own file.
start "" /b "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -WindowStyle Hidden -Command ^
    "$self = $env:ShutMeDownSelf; $folder = $env:ShutMeDownFolder; if ([string]::IsNullOrWhiteSpace($self) -or [string]::IsNullOrWhiteSpace($folder)) { exit 1 };" ^
    "for ($attempt = 0; $attempt -lt 60; $attempt++) { Start-Sleep -Milliseconds 500; try { if (Test-Path -LiteralPath $self) { Remove-Item -LiteralPath $self -Force -ErrorAction Stop }; break } catch { if ($attempt -eq 59) { exit 1 } } };" ^
    "for ($attempt = 0; $attempt -lt 60; $attempt++) { try { if (Test-Path -LiteralPath $folder) { Remove-Item -LiteralPath $folder -Recurse -Force -ErrorAction Stop }; exit 0 } catch { Start-Sleep -Milliseconds 500 } }; exit 1"
exit /b
