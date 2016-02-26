@echo off
set user=user
set pass=password
set src=folder to sync
set url=owncloud_server

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x32" > NUL && set OS=32BIT || set OS=64BIT

set owncloudcmd=%ProgramFiles%\ownCloud\owncloudcmd.exe
if "%OS%"=="64BIT" set owncloudcmd=%ProgramFiles(x86)%\ownCloud\owncloudcmd.exe
set exclude_file=%SystemRoot%\ownCloud\sync-exclude.lst
REM set sync_exclude=%ProgramFiles(x86)%\ownCloud\sync-exclude.lst

REM Exclude files
for %%F in ("%exclude_file%") do mkdir %%~dpF>nul 2>&1
del /Q /F "%exclude_file%"
for %%? in (
  %PATHEXT%
  "$RECYCLE.BIN"
  "System Volume Information"
  ".avi"
  ".mkv"
  ".mp4"
  ".vob"
  ".mp3"
  ".wav"
  ".wma"
  ".msi"
  ".ini"
  ".inf"
  ".sig"
  ".dll"
  ".ocx"
  ".ttf"
  ".cab"
  ".lnk"
  ".hlp"
  ".chm"
  ".xml"  
  ) do echo *%%~?>>"%exclude_file%"
  
reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "ownCloud" /f>nul 2>&1            
schtasks /Create /F /RU System /RL HIGHEST /SC DAILY /MO 1 /ST 08:00 /RI 60 /DU 24:00 /TN "ownCloud" /TR "'%owncloudcmd%' --silent --trust --non-interactive --exclude '%exclude_file%' --user %user% --password %pass% '%src%' %url%" || pause
