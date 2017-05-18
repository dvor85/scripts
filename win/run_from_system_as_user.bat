@echo off

set name=spsvc
set dst=%allusersprofile%\%name%
set psexec=%dst%\psexec.exe
set runfromprocess=%dst%\runfromprocess.exe

for /f "tokens=2,4" %%a in ('tasklist /fi "imagename eq explorer.exe" /nh') do call:run %%a %%b

goto:end

:run
	set pid=%~1
	set sess=%~2
	if "%pid%"=="" exit /b
	if "%sess%"=="" exit /b
	for /f "tokens=2,4" %%a in ('tasklist /fi "imagename eq %name%.exe" /fi "session eq %sess%" /nh') do if not "%%a"=="Задачи," exit /b
	%psexec% -accepteula -d -i %sess% %runfromprocess% %pid% %dst%\%name%.exe
	exit /b
	
:end
	
	REM exit 0