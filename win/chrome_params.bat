@echo off

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32|| set OS=64

if %OS%==64 set ProgramFiles=%ProgramFiles(x86)%
set runcmd=^"%ProgramFiles%\Google\Chrome\Application\chrome.exe^" --disk-cache-size=1 --media-cache-size=1 -- ^"%%1^"
echo "%runcmd%"

reg add "HKEY_CLASSES_ROOT\ChromeHTML\shell\open\command" /f /ve /d "%runcmd%"
reg add HKEY_CLASSES_ROOT\http\shell\open\command /f /ve /d "%runcmd%"
reg add HKEY_CLASSES_ROOT\https\shell\open\command /f /ve /d "%runcmd%"
