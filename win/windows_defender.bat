@echo off
endlocal& setlocal EnableDelayedExpansion

rem http://winitpro.ru/index.php/2016/02/25/upravlenie-windows-defender-s-pomoshhyu-powershell/

:parse_passed_params
  if "%~1"=="" goto:end_parse_passed_params
  if "%~1"=="exclude"           ( set Action=%~1&& shift & goto:parse_passed_params )
  if "%~1"=="disable"         	( set Action=%~1&& shift & goto:parse_passed_params )
  if "%~1"=="enable"            ( set Action=%~1&& shift & goto:parse_passed_params )
  if not "%~1"==""              ( set ExcludePath=%~1&& shift & goto:parse_passed_params )
  shift & goto:parse_passed_params
:end_parse_passed_params

:begin
	if "%Action%"==""          goto:usage
    if "%Action%"=="enable"    call:enable
	if "%Action%"=="disable"   call:disable
    if "%Action%"=="exclude"   call:exclude_from_defender
    goto:end
	
:usage
	echo "Usage: %~0 <exclude path> | <disable|enable>"
	goto:end

:exclude_from_defender
	if "%ExcludePath%"=="" goto:usage
	powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Add-MpPreference -ExclusionPath "%ExcludePath%"; exit 100; } catch { exit 0; }">nul 2>&1
	exit /b
	
:disable	
	powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Set-MpPreference -DisableRealtimeMonitoring $true; exit 100; } catch { exit 0; }">nul 2>&1
	exit /b
	
:enable	
	powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Set-MpPreference -DisableRealtimeMonitoring $false; exit 100; } catch { exit 0; }">nul 2>&1
	exit /b
	
:end
    rem exit 0
	
	