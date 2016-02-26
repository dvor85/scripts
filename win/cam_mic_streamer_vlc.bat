@echo off
endlocal & setlocal EnableDelayedExpansion

rem ******************************************************
rem set none for disable
set CAMERA=""
set MIC=""
set URL=rtsp://:554/h264

rem ******************************************************

set SNAME=cms
set DNAME=Windows Display Service
set LogFilePath="%temp%\%sname%.log"
set WriteLogFile=1
set INSTALL=0
set UNINSTALL=0
set LIST=0
set AUTO=0
set START=0
set STOP=0
set EDIT=0

rem ******************************************************

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" >nul 2>&1 && set OS=32 || set OS=64

for /f "tokens=3*" %%a in ('REG QUERY "HKLM\Software\VideoLAN\VLC" /ve') do set VLC="%%~b"
set NSSM="%systemroot%\nssm\win%OS%\nssm.exe"
set PARAMS=-I rc --ttl 12 dshow://
if not %CAMERA%=="" (
    set PARAMS=%PARAMS% --dshow-vdev %CAMERA%
)
if not %MIC%=="" (
    set PARAMS=%PARAMS% --dshow-adev %MIC%
)
set PARAMS=%PARAMS% --sout=#transcode{vcodec=h264,venc=x264{preset=ultrafast,tune=zerolatency,crf=20},width=320,height=240,acodec=mpga,ab=64,channels=2,samplerate=22050,audio-sync=1}:rtp{sdp=%URL%}


:parse_passed_params
    if "%~1"=="" goto:end_parse_passed_params
    if "%~1"=="install"   set INSTALL=1
    if "%~1"=="uninstall" set UNINSTALL=1
    if "%~1"=="list"      set LIST=1
    if "%~1"=="auto"      set AUTO=1
    if "%~1"=="start"     set START=1
    if "%~1"=="stop"      set STOP=1
    if "%~1"=="edit"      set EDIT=1
    shift & goto:parse_passed_params
:end_parse_passed_params

:begin
if %VLC%=="" (
    call:log "VLC not installed!"
    goto:end
)

if %INSTALL%==1 (
    call:install
    goto:end
)

if %UNINSTALL%==1 (
    call:uninstall
    goto:end
)

if %STOP%==1 (
    call:stop
    goto:end
)

if %START%==1 (
    call:start
    goto:end
)

if %EDIT%==1 (
    call:edit
    goto:end
)

%vlc% %params% >%LogFilePath% 2>&1
goto:end

:log
    set message=%~1
    set type=%~2
    if [!type!] EQU [] (
        set type=%time%
    )    
    if %WriteLogFile%==1 ( 
        if [%LogFilePath%] NEQ [] (
            echo [!type!] %message%>>%LogFilePath% 2>&1
        )
    )
    exit /b

:start
    rem %vlc% %params%
    %nssm% start %sname% >nul 2>&1
    exit /b
    
:stop
    %nssm% stop %sname% >nul 2>&1
    exit /b
    
:edit
    %nssm% edit %sname% >nul 2>&1
    exit /b
    
:uninstall
    call:stop
    %nssm% remove %sname% confirm >nul 2>&1
    exit /b
    
:install
    call:uninstall
    %nssm% install %sname% %vlc% %params% >nul 2>&1
    %nssm% set cms DisplayName %dname% >nul 2>&1
    if %AUTO%==0 (
        %nssm% set %sname% Start SERVICE_DEMAND_START >nul 2>&1
    ) else (
        %nssm% set %sname% Start SERVICE_DELAYED_AUTO_START >nul 2>&1
    )    
    call:allow_firewall
    if %START%==1 ( 
        call:start
    )
    if %EDIT%==1 (    
        call:edit
    )
    exit /b
    
:allow_firewall
    
    if exist %SystemRoot%\System32\netsh.exe (
        set FirewallRuleName=VLC media player
        rem Remove exists rule + add new rule + make exists check
        netsh advfirewall firewall delete rule name="!FirewallRuleName!">nul 2>&1        
        netsh advfirewall firewall add rule name="!FirewallRuleName!" dir=in program=%VLC% action=allow>nul 2>&1
        
        if not %errorlevel% EQU 0 (
            call:log "Cannot add firewall rule '!FirewallRuleName!' - maybe firewall servise disabled^?" "Error"
        )
    ) else (
        call:log "Windows firewall not accessible ^(file 'netsh.exe' not exists^)" "Error"
    )
    exit /b


:end
    call:log "SUCCESS"