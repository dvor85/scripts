@echo off
title "Disable Windows 7/8/8.1/10 Telemetry"
endlocal & setlocal EnableDelayedExpansion

rem Script created by <github.com/tarampampam> # 2015
rem Script edited by <github.com/dvor85> # 2016
rem Github: <https://gist.github.com/tarampampam/a0db45fb0de5976300b1>
rem OS: Windows 7/8/8.1/10
rem based on Version 0.2.14

echo.
echo   ***************************************************************************
echo   *                                                                         *
echo   *           Disable Windows 7/8/8.1 Telemetry (+bonus) service            *
echo   *                                                                         *
echo   ***************************************************************************
echo   *                                                                         *
echo   * Script support arguments:                                               *
echo   *                                                                         *
echo   *   -kb ^| -hotfixes Do NOT uninstall updates                              *
echo   *   -d ^| -disable   Do NOT disable updates                                *
echo   *   -t ^| -tasks     Do NOT disable tasks                                  *
echo   *   -s ^| -services  Do NOT disable services                               *
echo   *   -i ^| -ip        Do NOT block IP addresses using route                 *
echo   *   -f ^| -firewall  Do NOT block IP addresses using firewall              *
echo   *   -h ^| -hosts     Do NOT add domains to hosts file                      *
echo   *   -u ^| -updates   Do NOT change windows update settings                 *
echo   *   -l ^| -log       Do NOT write messages to .log file                    *
echo   *   -e ^| -exit      Exit when work is complete                            *
echo   *                                                                         *
echo   * Latest version you can find here: ^<http://goo.gl/1MzPtW^>                *
echo   *                                                                         *
echo   ***************************************************************************
echo   *                                                                         *
echo   *             PLEASE DISABLE YOUR ANTIVIRUS SOFTWARE BEFORE^^!              *
echo   *             (Sometimes it block access to hosts file, etc)              *
echo   *                                                                         *
echo   ***************************************************************************
echo.

rem Setup default script settings + declare variables
set ExitOnComplete=0
set WriteLogFile=1
set UninstallUpdates=1
set DisableUpdates=1
set DisableTasks=1
set DisableServices=1
set BlockIPaddresses=1
set BlockIPaddressesWithFirewall=1
set AddDomainsToHosts=1
set DisableAutomaticUpdates=1
set RemoveMetroApps=1

set FirewallIPlist=
set UpdatesList=
set result=
set LogFilePath="%~f0.log"

rem Parse passed arguments to script
:parse_passed_params
  if "%~1"=="" goto:end_parse_passed_params
  if "%~1"=="-e"        set ExitOnComplete=1
  if "%~1"=="-exit"     set ExitOnComplete=1
  if "%~1"=="-kb"       set UninstallUpdates=0
  if "%~1"=="-hotfixes" set UninstallUpdates=0
  if "%~1"=="-d"        set DisableUpdates=0
  if "%~1"=="-disable"  set DisableUpdates=0
  if "%~1"=="-t"        set DisableTasks=0
  if "%~1"=="-tasks"    set DisableTasks=0
  if "%~1"=="-s"        set DisableServices=0
  if "%~1"=="-services" set DisableServices=0
  if "%~1"=="-i"        set BlockIPaddresses=0
  if "%~1"=="-ip"       set BlockIPaddresses=0
  if "%~1"=="-f"        set BlockIPaddressesWithFirewall=0
  if "%~1"=="-firewall" set BlockIPaddressesWithFirewall=0
  if "%~1"=="-h"        set AddDomainsToHosts=0
  if "%~1"=="-hosts"    set AddDomainsToHosts=0
  if "%~1"=="-u"        set DisableAutomaticUpdates=0
  if "%~1"=="-updates"  set DisableAutomaticUpdates=0
  if "%~1"=="-l"        set WriteLogFile=0
  if "%~1"=="-log"      set WriteLogFile=0
  shift & goto:parse_passed_params
:end_parse_passed_params

goto:checkPermissions
:begin
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if "%OS%"=="64BIT" (
  if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    call:log "Must be run under 64bit cmd.exe" "ERROR"
    goto:end
  )
)

if %UninstallUpdates%==1 (
  call:title "Uninstall evil M$ updates.."
  rem You can find KB description here: https://support.microsoft.com/en-us/kb/%KB_NUMBER%
  rem 3080149 - Update for customer experience and diagnostic telemetry // 8.1 / WS 2012 R2, 7 SP1 / WS 2008 R2 SP1
  rem 3075249 - Update that adds telemetry points to consent.exe in Windows 8.1 and Windows 7 // 8.1 / RT 8.1 / WS 2012 R2 / 7 SP1 / WS 2008 R2 SP1
  rem 2952664 - Compatibility update for upgrading Windows 7 // 7 SP1
  rem 3035583 - Update installs Get Windows 10 app in Windows 8.1 and Windows 7 SP1 // 8.1 / 7 SP1 / IE11
  rem 3068708 - Update for customer experience and diagnostic telemetry // 8.1 / WS 2012 R2 / 7 SP1 / WS 2008 R2 SP1
  rem 3022345 - Update for customer experience and diagnostic telemetry // WS 2012 R2 / 8.1 / WS 2008 R2 SP1 / 7 SP1
  rem 3021917 - Update to Windows 7 SP1 for performance improvements // 7 SP1
  rem 2976978 - Compatibility update for Windows 8.1 and Windows 8 // 8 / 8.1
  rem 3044374 - Update that enables you to upgrade from Windows 8.1 to Windows 10 // WS 2012 R2 / 8.1
  rem 2990214 - Update that enables you to upgrade from Windows 7 to a later version of Windows // WS 2008 R2 SP1 / 7 SP1
  rem 971033 - Update for Windows Activation Technologies // 7
  rem 3075851 - Windows Update Client for Windows 7 and Windows Server 2008 R2: August 2015 // WS 2008 R2 SP1 / 7 SP1 / Embedded Standard 7 SP1
  rem 3065988 - Windows Update Client for Windows 8.1 and Windows Server 2012 R2: July 2015 more info // WS 2012 R2 / 8.1
  rem 3083325 - Windows Update Client for Windows 8.1 and Windows Server 2012 R2: September 2015 more info // WS 2012 R2 / 8.1
  rem 3083324 - Windows Update Client for Windows 7 and Windows Server 2008 R2: September 2015 more info // WS 2008 R2 / 7
  rem 3075853 - Windows Update Client for Windows 8.1 and Windows Server 2012 R2: August 2015 more info // WS 2012 R2 / 8.1
  rem 3065987 - Windows Update Client for Windows 7 and Windows Server 2008 R2: July 2015 more info // WS 2008 R2 / 7
  rem 3050265 - Windows Update Client for Windows 7: June 2015 more info // WS 2008 R2 / 7
  rem 3050267 - Windows Update Client for Windows 8.1: June 2015 more info // WS 2012 R2 / 8.1
  rem 3046480 - Update helps to determine whether to migrate the .NET Framework 1.1 when you upgrade Windows 8.1 or Windows 7 more info // 7 SP1 / 8.1
  rem 2882822 - Update adds ITraceRelogger interface support // 7 SP1 / WS 2008 R2
  rem 3083710 - Windows Update Client for Windows 7 and Windows Server 2008 R2: October 2015 // 7 SP1 / WS 2008 R2
  rem 3083711 - Windows Update Client for Windows 8.1 and Windows Server 2012 R2: October 2015 // 8.1 / WS 2012 R2
  rem 3112343 - Windows Update Client for Windows 7 and Windows Server 2008 R2: December 2015 // 7 / WS 2008 R2
  rem 3112336 - Windows Update Client for Windows 8.1 and Windows Server 2012 R2: December 2015 // 8.1 / WS 2012 R2
  rem 3112336 - Updated capabilities to upgrade Windows 8.1 and Windows 7 // 8.1 / 7 SP1
  rem 3112336 - Windows Update Client for Windows 7 and Windows Server 2008 R2: February 2016 // 7 SP1 / WS 2008 R2 / Embedded Standard 7 SP1
  for %%? in (
    "3080149"   
    "3075249"
    "2952664"
    "3035583"
    "3068708"
    "3022345"
    "3021917"
    "2976978"
    "3044374"
    "2990214"
    "971033"
    "3075851"
    "3065988"
    "3083325"
    "3083324"
    "3075853"
    "3065987"
    "3050265"
    "3050267"
    "3046480"
    "2882822"
    "3083710"
    "3083711"
    "3112343"
    "3112336"
    "3135445"
    "3123862"
  ) do call:uninstall_update %%?
)

if %DisableUpdates%==1 (
  call:title "Disable ^(hide^) uninstalled updates.."
  call:log "It can take a lot of time - wait please, or use -d flag for disable this feature.." "Notice"
  rem For using this shit you must init updates list by calling 'call:uninstall_update "123123"' first!
  call:disable_updates
)

if %DisableTasks%==1 (
  call:title "Disable some windows tasks.."
  for %%? in (
    "\Microsoft\Windows\Application Experience\AitAgent"
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Autochk\Proxy"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\PI\Sqm-Tasks"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    "\Microsoft\Windows\Maintenance\WinSAT"
    "\Microsoft\Windows\Media Center\ActivateWindowsSearch"
    "\Microsoft\Windows\Media Center\ConfigureInternetTimeService"
    "\Microsoft\Windows\Media Center\DispatchRecoveryTasks"
    "\Microsoft\Windows\Media Center\ehDRMInit"
    "\Microsoft\Windows\Media Center\InstallPlayReady"
    "\Microsoft\Windows\Media Center\mcupdate"
    "\Microsoft\Windows\Media Center\MediaCenterRecoveryTask"
    "\Microsoft\Windows\Media Center\ObjectStoreRecoveryTask"
    "\Microsoft\Windows\Media Center\OCURActivate"
    "\Microsoft\Windows\Media Center\OCURDiscovery"
    "\Microsoft\Windows\Media Center\PBDADiscovery"
    "\Microsoft\Windows\Media Center\PBDADiscoveryW1"
    "\Microsoft\Windows\Media Center\PBDADiscoveryW2"
    "\Microsoft\Windows\Media Center\PvrRecoveryTask"
    "\Microsoft\Windows\Media Center\PvrScheduleTask"
    "\Microsoft\Windows\Media Center\RegisterSearch"
    "\Microsoft\Windows\Media Center\ReindexSearchRoot"
    "\Microsoft\Windows\Media Center\SqlLiteRecoveryTask"
    "\Microsoft\Windows\Media Center\UpdateRecordPath"
    "\Microsoft\Windows\AppID\SmartScreenSpecific"
    "\Microsoft\Windows\Application Experience\StartupAppTask"
    "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM"
    "\Microsoft\Windows\Customer Experience Improvement Program\HypervisorFlightingTask"
    "\Microsoft\Windows\FileHistory\File History ^(maintenance mode^)"
    "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
    "\Microsoft\Windows\Shell\FamilySafetyMonitor"
    "\Microsoft\Windows\Shell\FamilySafetyRefresh"
    "\Microsoft\Windows\WindowsUpdate\Automatic App Update"
  ) do call:disable_task %%?
)

if %DisableServices%==1 (
  call:title "Disable services.."
  for %%? in (
    "Diagtrack"
    "dmwappushservice"
    "WerSvc"
    "diagnosticshub.standardcollector.service"
    "RemoteRegistry"
    "WMPNetworkSvc"
    "WSearch"    
  ) do call:disable_service %%?
  
  call:disable_telemetry
  
)

if %BlockIPaddresses%==1 (
  call:title "Block M$ servers IP addresses.."
  for %%? in (
    "111.221.29.177"
    "111.221.29.253"
    "131.253.40.37"
    "134.170.30.202"
    "134.170.115.60"
    "134.170.165.248"
    "134.170.165.253"
    "134.170.185.70"
    "137.116.81.24"
    "137.117.235.16"
    "157.55.129.21"
    "157.55.133.204"
    "157.56.121.89"
    "157.56.91.77"
    "168.63.108.233"
    "184.86.56.12"
    "185.13.160.61"
    "191.232.139.254"
    "191.232.80.58"
    "191.232.80.62"
    "191.237.208.126"
    "204.79.197.200"
    "207.46.101.29"
    "207.46.114.58"
    "207.46.223.94"
    "207.68.166.254"
    "212.30.134.204"
    "212.30.134.205"
    "23.102.21.4"
    "23.99.10.11"
    "23.218.212.69"
    "64.4.54.22"
    "64.4.54.32"
    "64.4.6.100"
    "65.39.117.230"
    "65.52.100.11"
    "65.52.100.7"
    "65.52.100.9"
    "65.52.100.91"
    "65.52.100.92"
    "65.52.100.93"
    "65.52.100.94"
    "65.52.108.29"
    "65.55.108.23"
    "65.55.138.114"
    "65.55.138.126"
    "65.55.138.186"
    "65.55.252.63"
    "65.55.252.71"
    "65.55.252.92"
    "65.55.252.93"
    "65.55.29.238"
    "65.55.39.10"
  ) do call:block_route %%?
)

if %BlockIPaddressesWithFirewall%==1 (
  call:title "Add blocked IP adressess to firewall rule.."
  rem For using this shit you must init IP addresses list by calling 'call:block_route "1.1.1.1"' first!
  call:block_routes_with_firewall
)

if %AddDomainsToHosts%==1 (
  call:title "Find and add M$ domains to HOSTS file ^(block^).."
  for %%? in (
    "--title--"
    "msedge.net"
    "a-msedge.net"
    "a-0001.a-msedge.net"
    "a-0002.a-msedge.net"
    "a-0003.a-msedge.net"
    "a-0004.a-msedge.net"
    "a-0005.a-msedge.net"
    "a-0006.a-msedge.net"
    "a-0007.a-msedge.net"
    "a-0008.a-msedge.net"
    "a-0009.a-msedge.net"
    "a1095.g2.akamai.net"
    "ad.doubleclick.net"
    "adnexus.net"
    "adnxs.com"
    "secure.adnxs.com"
    "m.adnxs.com"
    "ads1.msads.net"
    "ads1.msn.com"
    "ads2.msn.com"
    "flex.msn.com"
    "g.msn.com"
    "h2.msn.com"
    "h1.msn.com"
    "a.ads1.msn.com"
    "a.ads2.msn.com"
    "a.ads2.msads.net"
    "live.rads.msn.com"
    "ads2.msn.com.c.footprint.net"
    "aka-cdn-ns.adtech.de"
    "az361816.vo.msecnd.net"
    "az512334.vo.msecnd.net"
    "bs.serving-sys.com"
    "msntest.serving-sys.com"
    "telemetry.microsoft.com"
    "ca.telemetry.microsoft.com"
    "c.msn.com"
    "aidps.atdmt.com"
    "view.atdmt.com"
    "ec.atdmt.com"
    "c.atdmt.com"
    "db3aqu.atdmt.com"
    "cdn.atdmt.com"
    "choice.live.com"
    "choice.microsoft.com"
    "choice.microsoft.com.nsatc.net"
    "compatexchange.cloudapp.net"
    "corpext.msitadfs.glbdns2.microsoft.com"
    "corp.sts.microsoft.com"
    "cs1.wpc.v0cdn.net"
    "df.telemetry.microsoft.com"
    "e9946.g.akamaiedge.net"
    "fe2.update.microsoft.com.akadns.net"
    "fe3.delivery.dsp.mp.microsoft.com.nsatc.net"
    "microsoft-hohm.com"
    "feedback.microsoft-hohm.com"
    "feedback.search.microsoft.com"
    "feedback.windows.com"
    "i1.services.social.microsoft.com"
    "i1.services.social.microsoft.com.nsatc.net"
    "i.s1.social.ms.akadns.net"
    "lb1.www.ms.akadns.net"
    "legacy-redirection-neurope-prod-hp.cloudapp.net"
    "oca.telemetry.microsoft.com"
    "oca.telemetry.microsoft.com.nsatc.net"
    "onesettings-hk2.metron.live.com.nsatc.net"
    "pre.footprintpredict.com"
    "preview.msn.com"
    "ads.msn.com"
    "rad.msn.com"
    "rad.live.com"
    "b.rad.msn.com"
    "b.ads2.msads.net"
    "b.ads1.msn.com"
    "ac3.msn.com"
    "a.rad.msn.com"
    "cds26.ams9.msecn.net"
    "secure.flashtalking.com"
    "static.2mdn.net"
    "s0.2mdn.net"
    "redirection.prod.cms.msn.com"
    "redirection.prod.cms.msn.com.akadns.net"
    "redir.metaservices.microsoft.com"
    "redir.metaservices.microsoft.com.akadns.net"
    "redir.metaservices.microsoft.com.edgesuite.net"
    "wes.df.telemetry.microsoft.com"
    "reports.wes.df.telemetry.microsoft.com"
    "services.wes.df.telemetry.microsoft.com"
    "settings.data.glbdns2.microsoft.com"
    "settings.data.microsoft.com"
    "settings-sandbox.data.glbdns2.microsoft.com"
    "settings-sandbox.data.microsoft.com"
    "settings-win.data.microsoft.com"
    "schemas.microsoft.akadns.net"
    "siweb.microsoft.akadns.net"
    "sls.update.microsoft.com.akadns.net"
    "spynet2.microsoft.akadns.net"
    "spynet2.microsoft.com"
    "spynetalt.microsoft.akadns.net"
    "spynetalt.microsoft.com"
    "spyneteurope.microsoft.akadns.net"
    "sqm.df.telemetry.microsoft.com"
    "sqm.telemetry.microsoft.com"
    "sqm.telemetry.microsoft.com.nsatc.net"
    "ssw.live.com"
    "ssw.live.com.nsatc.net"
    "statsfe1.ws.microsoft.com"
    "statsfe1.ws.microsoft.com.nsatc.net"
    "statsfe2.update.microsoft.com.akadns.net"
    "statsfe2.ws.microsoft.com"
    "statsfe2.ws.microsoft.com.nsatc.net"
    "support.msn.microsoft.akadns.net"
    "watson.microsoft.com"
    "survey.watson.microsoft.com"
    "telecommand.telemetry.microsoft.com"
    "telecommand.telemetry.microsoft.com.nsatc.net"
    "telemetry.appex.bing.net"
    "telemetry.appex.search.prod.ms.akadns.net"
    "telemetry.urs.microsoft.com"
    "t.urs.microsoft.com.nsatc.net"
    "vortex.data.glbdns2.microsoft.com"
    "vortex.data.metron.live.com.nsatc.net"
    "vortex-bn2.metron.live.com.nsatc.net"
    "vortex-cy2.metron.live.com.nsatc.net"
    "vortex.data.microsoft.com"
    "vortex-db5.metron.live.com.nsatc.net"
    "vortex-sandbox.data.glbdns2.microsoft.com"
    "vortex-sandbox.data.microsoft.com"
    "vortex-win.data.metron.live.com.nsatc.net"
    "vortex-win.data.microsoft.com"
    "watson.live.com"
    "watson.microsoft.com.nsatc.net"
    "watson.ppe.telemetry.microsoft.com"
    "watson.telemetry.microsoft.com"
    "watson.telemetry.microsoft.com.nsatc.net"
  ) do call:add_to_hosts %%?
)

if %DisableAutomaticUpdates%==1 (
  call:title "Disable automatic windows update ^(make search, but you must manually select updates to install^)"
  call:reg_add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" AUOptions 2
  call:reg_add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" IncludeRecommendedUpdates 0
  call:create_mse_update_task
)

if %RemoveMetroApps%==1 (
  call:title "Remove Metro Apps"
  call:remove_metro_apps
)



goto:end

:log
  set message=%~1
  set type=%~2
  if [!type!] EQU [] (
    set type=%time%
  )
  echo [!type!] %message%
  if %WriteLogFile%==1 ( if [%LogFilePath%] NEQ [] (
    echo [!type!] %message%>>%LogFilePath% 2>&1
  ))
  exit /b
  
:title
  set title=%~1
  echo.
  echo [i] %title%
  if %WriteLogFile%==1 ( if [%LogFilePath%] NEQ [] (
    echo.>>%LogFilePath% 2>&1
    echo [i] %title%>>%LogFilePath% 2>&1
  ))
  exit /b
  
:reg_add
  set root="%~1"
  set param="%~2"
  set val=%~3
  reg query !root!>nul 2>&1 & if %errorLevel%==0 (
    reg add !root! /v !param! /t REG_DWORD /d !val! /f>nul
  )
  exit /b

:checkPermissions
  if exist %SystemRoot%\System32\fsutil.exe (
    fsutil dirty query %systemdrive%>nul 2>&1
  ) else (
    net session >nul 2>&1
  )
  if %errorLevel%==0 (
    goto:begin
  ) else (
    call:log "[Failure] Need administrative permissions"
    goto:end
  )
  exit /b
  
:download_file
  set url=%~1
  set dest=%~2
  rem powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Import-Module BitsTransfer; Start-BitsTransfer -Source %url% -Destination %dest%; exit 100; } catch { exit 0; }">nul
  set ccmd="try { (New-Object System.Net.WebClient).DownloadFile( \"%url%\", \"%dest%\" ); exit 100; } catch { exit 0; }"
  powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command %ccmd%>nul  
  exit /b

:install_pswu_module
  set ps_modules_dir=%windir%\System32\WindowsPowerShell\v1.0\Modules
  set pswu_distr_path="!ps_modules_dir!\PSWindowsUpdate"
  set result=0
  if exist "!pswu_distr_path!\Hide-WUUpdate.ps1" (
    rem call:log "PowerShell module 'PSWindowsUpdate' found"
    set result=100
  ) else (
    set local_unzip_tool=0
    set local_pswu_module=0
    call:log "Install PowerShell module 'PSWindowsUpdate'" "Install update"
    if exist "%~dp0\unzip.exe" (
      set local_unzip_tool=1
      set unzip_tool="%~dp0\unzip.exe"
      call:log "Local unzip tool found"
    ) else (
      set unzip_tool="%temp%\unzip.exe"
      call:log "Download unzip tool.."
      rem Original source: http://stahlworks.com/dev/unzip.exe
      call:download_file "https://github.com/dvor85/scripts/raw/master/win/unzip.exe" !unzip_tool!
    )
    if exist !unzip_tool! (
      if exist "%~dp0\PSWindowsUpdate.zip" (
        set local_pswu_module=1
        set pswu_zip="%~dp0\PSWindowsUpdate.zip"
        call:log "Local PSWindowsUpdate module found"
      ) else (
        set pswu_zip="%temp%\PSWindowsUpdate.zip"
        call:log "Download PowerShell module 'PSWindowsUpdate'.."
        rem Original source: https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/
        call:download_file "https://github.com/dvor85/scripts/raw/master/win/PSWindowsUpdate.zip" !pswu_zip!
      )
      if exist !pswu_zip! (
        set pswu_temp="%temp%\pswindowsupdate_content"
        call:log "Unzip module archive.."
        !unzip_tool! -oC !pswu_zip! -d !pswu_temp!>nul
        if exist !pswu_temp! (
          call:log "Move module files to PowerShell modules directory.."
          if exist !pswu_distr_path! (rmdir !pswu_distr_path! /s /q>nul)
          mkdir !pswu_distr_path!>nul
          xcopy /Y /E /H /Q "!pswu_temp!\PSWindowsUpdate" !pswu_distr_path!>nul
          REM move /y "!pswu_temp!\PSWindowsUpdate" !ps_modules_dir!>nul
          if "!local_unzip_tool!" NEQ "1"  (del /f !unzip_tool!>nul)
          if "!local_pswu_module!" NEQ "1" (del /f !pswu_zip!>nul)
          rmdir !pswu_temp! /s /q>nul
          if exist "!pswu_distr_path!\Hide-WUUpdate.ps1" (
            call:log "'PSWindowsUpdate' module for PowerShell installed" "Installation complete"
            set result=100
            timeout /t 2 /nobreak>nul & taskkill /f /im powershell.exe>nul 2>&1 & timeout /t 2 /nobreak>nul
          ) else (
            call:log "Installation module 'PSWindowsUpdate' failed - files in !pswu_distr_path! not found" "Installation failed"
          )
        )
      )
    )
  )
  exit /b
  
:uninstall_update
  set kb_id=%~1
  rem Remove update
  call:log "Uninstall update KB%kb_id%.."
  start /wait wusa /uninstall /norestart /quiet /kb:%kb_id%
  if %errorlevel%==2359303 call:log "Update KB%kb_id% not installed"
  if %errorlevel%==1223 call:log "Uninstall cancelled"
  if %errorlevel%==3010 call:log "Update KB%kb_id% UNINSTALLED successfully"
  rem Add all updates IDs to single string variable (',' is delimiter)
  set UpdatesList=%UpdatesList%KB%kb_id%,
  exit /b
  
:disable_updates
  rem Add update to Windows Update exceptions (hide update) using PowerShell
  if [!UpdatesList!] EQU [] (
    call:log "Empty updates list. For add update ID to block list - uninstall update by script before" "Error"
    exit /b
  )
  rem Remove last (',') char
  set UpdatesListForDisabling=!UpdatesList:~0,-1!
  call:install_pswu_module
  if %result%==100 (
    call:log "Disable updates: !UpdatesListForDisabling!.."
    powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "Import-Module PSWindowsUpdate; try { Hide-WUUpdate -KBArticleID !UpdatesListForDisabling! -Confirm:$false; exit 100; } catch { exit 0; }">nul 2>&1
    if !errorlevel!==100 (
      call:log "Updates successfully DISABLED"
    ) else (
      call:log "Cannot disable updates: Update your PowerShell or install PowerShell module 'PSWindowsUpdate'" "Error"
    )
  )
  exit /b
  
:block_route
  set REDIRECT=0.0.0.0
  set ip_addr=%~1
  call:log "Block route to %ip_addr%"
  route -p ADD %ip_addr% MASK 255.255.255.255 %REDIRECT%>nul 2>&1
  rem Add all addresses to single string variable (',' is delimiter)
  set FirewallIPlist=%FirewallIPlist%%ip_addr%,
  exit /b
  
:block_routes_with_firewall
  if [!FirewallIPlist!] EQU [] (
    call:log "Empty IP list. For add IP to firewall block list - block ip by route first" "Error"
    exit /b
  )
  if exist %SystemRoot%\System32\netsh.exe (
    set FirewallRuleName=Block MS Telemetry
    rem Remove exists rule + add new rule + make exists check
    netsh advfirewall firewall delete rule name="!FirewallRuleName!">nul
    netsh advfirewall firewall add rule name="!FirewallRuleName!" dir=out action=block remoteip=!FirewallIPlist! interfacetype=any>nul
    netsh advfirewall firewall show rule name="!FirewallRuleName!">nul
    if %errorlevel% EQU 0 (
      call:log "IP adresses blocked with firewall rule '!FirewallRuleName!': '!FirewallIPlist:~0,-1!'"
    ) else (
      call:log "Cannot add firewall rule '!FirewallRuleName!' - maybe firewall servise disabled^?" "Error"
    )
  ) else (
    call:log "Windows firewall not accessible (file 'netsh.exe' not exists)" "Error"
  )
  exit /b
  
:create_mse_update_task
  set MSE=("%ProgramFiles%\Microsoft Security Client\MpCmdRun.exe","%ProgramFiles%\Windows Defender\MpCmdRun.exe")
  for %%? in %MSE% do ( 
    if exist %%? (
      call:log "Create Microsoft Esential Security update task"
	  schtasks /Create /F /SC DAILY /MO 1 /ST 08:00 /RI 60 /DU 24:00 /RL HIGHEST /RU System /TN "MSE Update" /TR "'%%~?' -SignatureUpdate -ScheduleJob -RestrictPrivileges">nul
      if %errorlevel% EQU 0 (
        call:log "Create MSE Update task SUCCESS"
      ) else (
        call:log "Cannot create MSE update task" "Error"
      )
      exit /b
    )
  )
  exit /b

:disable_task
  set task_name=%~1
  call:log "Disable task %task_name%"
  schtasks /Change /TN "%task_name%" /DISABLE>nul 2>&1
  exit /b

:disable_service
  set service_name=%~1
  set errors_counter=0
  call:log "Disable service '%service_name%'"
  sc query "%service_name%">nul
  if %errorlevel% NEQ 1060 (
    sc config "!service_name!" start= disabled>nul
    if %errorlevel% NEQ 0 set /a errors_counter=errors_counter+1
    sc stop "!service_name!">nul
    if %errorlevel% NEQ 0 set /a errors_counter=errors_counter+1
    if %errors_counter%==0 (
      call:log "Service '!service_name!' disabled successful"
    )
  ) else set /a errors_counter=errors_counter+1 & call:log "Service '!service_name!' not installed"
  exit /b

:add_to_hosts
  set HOSTS=%SystemRoot%\system32\drivers\etc\hosts
  set REDIRECT=0.0.0.0
  set block_title=## Block MS telemetry domain names
  set write_title=0
  set host_name=%~1
  if "%host_name%"=="--title--" (
    set write_title=1
    set host_name=%block_title%
  )
  find /C /I "%host_name%" %HOSTS%>nul
  if %errorlevel% NEQ 0 (
    attrib -r %HOSTS%>nul
    if !write_title! EQU 1 (
      echo.>>%HOSTS%
      echo.>>%HOSTS%
      echo %block_title%>>%HOSTS%
    ) else (
      echo %REDIRECT% %host_name%>>%HOSTS%
      call:log "Domain %host_name% ADDED"
    )
  ) else (
    if !write_title! NEQ 1 (
      call:log "Domain %host_name% ALREADY added"
    )
  )
  exit /b
  
:disable_telemetry
  REM --- Отключение телеметрии и сбора данных --- 
  call:reg_add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" AllowTelemetry 0
  call:reg_add "HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting" Disabled 1
  call:reg_add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" PreventDeviceMetadataFromNetwork 1
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\MRT" DontOfferThroughWUAU 1
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" CEIPEnable 0
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" AITEnable 0
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" DisableUAR 1
  call:reg_add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" Start 0
  call:reg_add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" Start 0
  call:reg_add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" NumberOfSIUFInPeriod 0
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" AllowCortana 0
  
  del /f %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl>nul 2>&1
  reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /f>nul 2>&1
  reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{12D4C69E-24AD-4923-BE19-31321C43A767}" /f>nul 2>&1
  call:disable_onedrive
  
  
  exit /b  
  
:disable_onedrive
  REM --- Полное отключение OneDrive --- 
  TASKKILL /F /IM OneDrive.exe /T>nul 2>&1
  call:reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" DisableFileSyncNGSC 1
  call:reg_add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" System.IsPinnedToNameSpaceTree 0
  reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f>nul 2>&1
  
  exit /b
  
:remove_metro_apps
  powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Get-AppxProvisionedPackage -online | Remove-AppxProvisionedPackage -online; Get-AppXPackage -AllUsers | Remove-AppxPackage; exit 100; } catch { exit 0 }">nul 2>&1
 
  exit /b
  
  
:end
  call:title "Exit after 60 seconds, or press any key for exit now"
  timeout /t 60>nul 2>&1  
  endlocal & if %ExitOnComplete%==1 (exit)
  echo on
