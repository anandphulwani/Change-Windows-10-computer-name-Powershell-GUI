start C:\ChangeComputerName\ChangeComputerName.exe
CSCRIPT C:\ChangeComputerName\SLEEP.VBS 500 >nul
:wait
CSCRIPT C:\ChangeComputerName\SLEEP.VBS 5 >nul
tasklist |findstr /i /L /c:"ChangeComputerName.exe" >nul
if not errorlevel 1 goto wait
:QUIT
rmdir /S /Q C:\ChangeComputerName
start /b "" cmd /c "del "%~f0" & exit /b"
REM Below line also does the same job, as the above line, since initially i thought that the above line is generating a flashing window, when in reality it wasnt, so the below line can also be used to hide window, an extra command for future reference
REM C:\ChangeComputerName\nircmd.exe execmd start /b del "%~f0" & exit /b