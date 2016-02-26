@echo off
endlocal & setlocal EnableDelayedExpansion

rem ******************************************************
rem ********* MUST BE SET FOR EACH COMPUTER **************

set CAMERA=\"HD WebCam\"
set MIC=\"Микрофон (Realtek High Definiti\"
set URL=udp://239.192.0.220:1234?pkt_size=1316

rem ******************************************************

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x32" >nul 2>&1 && set OS=32 || set OS=64
set SNAME=cms
set NSSM="%systemroot%\ffmpeg_nssm\win%OS%\nssm.exe"
set FFMPEG="%systemroot%\ffmpeg_nssm\win%OS%\ffmpeg.exe"
set PARAMS=-y -f dshow -threads auto -i video=%CAMERA%:audio=%MIC% ^
-vcodec libx264 -preset ultrafast -tune zerolatency -r 10 -async 1 ^
-acodec libmp3lame -ab 24k -ar 22050 ^
-bsf:v h264_mp4toannexb -maxrate 750k -bufsize 3000k -f mpegts %URL%

set INSTALL=0
set UNINSTALL=0
set LIST=0
set AUTO=0
set START=0
set STOP=0

:parse_passed_params
    if "%~1"=="" goto:end_parse_passed_params
    if "%~1"=="install"   set INSTALL=1
    if "%~1"=="uninstall" set UNINSTALL=1
    if "%~1"=="list"      set LIST=1
    if "%~1"=="auto"      set AUTO=1
    if "%~1"=="start"     set START=1
    if "%~1"=="stop"      set STOP=1
    shift & goto:parse_passed_params
:end_parse_passed_params

if %LIST%==1 (
    call:list
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

:start
    %nssm% start %sname% >nul 2>&1
    exit /b
    
:stop
    %nssm% stop %sname% >nul 2>&1
    exit /b
    
:uninstall
    call:stop
    %nssm% remove %sname% confirm >nul 2>&1
    exit /b
    
:install
    call:uninstall
    %nssm% install %sname% %ffmpeg% %params% >nul 2>&1
    if %AUTO%==0 (
        %nssm% set %sname% Start SERVICE_DEMAND_START >nul 2>&1
    ) else (
        %nssm% set %sname% Start SERVICE_DELAYED_AUTO_START >nul 2>&1 || %nssm% set %sname% Start SERVICE_AUTO_START >nul 2>&1
    )    
    if %START%==1 ( 
        call:start
    )
    exit /b
    
:list
    %ffmpeg% -list_devices true -f dshow -i dummy > "%temp%\%sname%.log" 2>&1
    exit /b



:end
