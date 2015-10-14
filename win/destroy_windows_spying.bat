REM chcp 1251 >nul 
@echo 
 
REM --- ���������� ����� ��������������, �������� � ����� ���� ��� �������� --- 
net stop DiagTrack 
net stop diagnosticshub.standardcollector.service 
net stop dmwappushservice 
net stop RemoteRegistry 
net stop WMPNetworkSvc 
net stop WSearch 
sc config DiagTrack start= disabled 
sc config diagnosticshub.standardcollector.service start= disabled 
sc config dmwappushservice start= disabled 
sc config RemoteRegistry start= disabled 
sc config WMPNetworkSvc start= disabled 
sc config WSearch start= disabled 
REM sc delete dmwappushservice  
REM sc delete diagtrack 
 
 
REM --- ���������� ���������� � ����� ������ --- 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f 
DEL /p C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl 
 
REM --- ������� ������������ ������� "�������" --- 
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f 
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /f 
 
 
REM --- ���������� ������� � ������������ �� ����� ����� ���������� ��� ��������� � ��. --- 
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable 
schtasks /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable 
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable 
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable 
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable 
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable 
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable 
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable 
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable 
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /Disable 
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\HypervisorFlightingTask" /Disable 
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable 
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable 
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable 
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable 
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable 
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /Disable 
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable 
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable 
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable 
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable 

REM --- ����� ��������� � �������� ���������� --- 
REM --- 0 = Off (������ �� Microsoft) ---  
REM --- 1 = �������� �� Microsoft � ����. � ��������� ���� ---  
REM --- 3 = �������� �� Microsoft, ����. � ��������� ���� � ����. � ��������� (��� torrents) ---  
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f 
 
REM --- ���������� Cortana --- 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f 
 
REM --- ������ ���������� OneDrive --- 
TASKKILL /F /IM OneDrive.exe /T 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f 
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f 
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f 
 
REM --- �������� ���������� �� ������� "���� ���������" --- 
REM --- 1 = ���� ���������, 2 = ������ �������� ������� ---  
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f 
 
REM --- ����������� ������ "���� ���������" �� ������� ����� --- 
REM --- 0 = ��������, 1 = ������ ---  
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f  
 
REM --- ��������� �������� ����������� ����������� ������ ����� �� 10 ������ --- 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ExtendedUIHoverTime" /t REG_DWORD /d "10000" /f 
 
REM --- ���������� ��������� ������� SHIFT ����� 5 ������� --- 
REM --- 506 = ����, 510 = �������� (�� ���������) ---  
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f 
 
REM --- �������� "Retail Demo" "������� ����� ��� ��������� ��������" --- 
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{12D4C69E-24AD-4923-BE19-31321C43A767}" /f 
 
REM --- ���������� ������� ����� � ����� � ���������� --- 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f 
 
REM --- ���������� ���������� ������ � ���������� --- 
REM --- 0 = ���������� --- 
REM --- 1 = �������� --- 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f 
 
REM --- ���������� ����������� ������� "���������� ������" � ��������� ������ �� ��� ���� --- 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "NoPreviousVersionsPage" /t REG_DWORD /d 1 /f 
 
@pause 