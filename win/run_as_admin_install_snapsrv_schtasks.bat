schtasks /END /TN "snapsrv"
taskkill /T /F /IM snapsrv.exe
set snapsrv_src=\\engarde\delay
set snapsrv_dst=%ALLUSERSPROFILE%\snapsrv
set files=("snapsrv.exe","snapsrv.ini","snapsrv2.ini")
mkdir "%snapsrv_dst%\"
for %%? in %files% do (  
  copy /B /Y "%snapsrv_src%\%%~?" "%snapsrv_dst%\"
)
reg ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v "snapsrv" /t REG_SZ /d "%snapsrv_dst%\snapsrv.exe" /f 
netsh advfirewall firewall del rule name=snapsrv
netsh advfirewall firewall del rule name=tmp_snapsrv
netsh advfirewall firewall add rule name="snapsrv" dir=in protocol=tcp localport=8118 action=allow || netsh firewall add portopening protocol=TCP port=8118 name=snapsrv
netsh advfirewall firewall add rule name="snapsrv" dir=in protocol=tcp localport=8228 action=allow || netsh firewall add portopening protocol=TCP port=8228 name=snapsrv
schtasks /Create /F /RU System /RL HIGHEST /SC ONSTART /TN "snapsrv" /TR "'%snapsrv_dst%\snapsrv.exe' config='%snapsrv_dst%\snapsrv2.ini'" || schtasks /Create /RU System /SC ONSTART /TN "snapsrv" /TR "'%snapsrv_dst%\snapsrv.exe' config='%snapsrv_dst%\snapsrv2.ini'" 
schtasks /RUN /TN "snapsrv"



