set snapsrv_dst=%ALLUSERSPROFILE%\snapsrv
schtasks /END /TN "snapsrv"
schtasks /DELETE /F /TN "snapsrv"
taskkill /T /F /IM snapsrv.exe
reg DELETE HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "snapsrv" /f
del /S /Q /F %snapsrv_dst%


