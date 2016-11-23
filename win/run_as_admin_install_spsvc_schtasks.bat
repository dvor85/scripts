@echo off
set spsvc=spsvc
set sp_src=\\engarde\delay\spsvc
set sp_dst=%ALLUSERSPROFILE%\.spclient
set snapsrv=snapsrv

rem remove snapsrv
taskkill /F /IM "%snapsrv%.exe"
schtasks /DELETE /F /TN "%snapsrv%"
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "%snapsrv%" /f
del /F /Q /S %ALLUSERSPROFILE%\%snapsrv%

rem install spsvc
taskkill /T /F /IM "%spsvc%.exe"
schtasks /DELETE /F /TN "%spsvc%"
mkdir "%sp_dst%\"
copy /B /Y "%sp_src%\main.exe" "%sp_dst%\%spsvc%.exe"
reg ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "%spsvc%" /t REG_SZ /d "%sp_dst%\%spsvc%.exe" /f 
schtasks /Create /F /RU System /RL HIGHEST /SC ONSTART /TN "%spsvc%" /TR "%sp_dst%\%spsvc%.exe" || schtasks /Create /RU System /SC ONSTART /TN "snapsrv" /TR "%sp_dst%\%spsvc%.exe" 
schtasks /RUN /TN "%spsvc%"



