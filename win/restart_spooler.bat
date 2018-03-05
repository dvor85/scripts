@echo off
endlocal& setlocal EnableDelayedExpansion
set spooler="spoolsv.exe"

:begin
    for /f "tokens=1 delims=," %%a in ('tasklist /FI "CPUTIME gt 00:01:00" /FI "IMAGENAME eq %spooler%" /FO CSV /NH') do (	
        set spool=%%a
		if not "!spool!"=="%spooler%" echo call:run
	)
    goto:end
    
:run
    net stop spooler
    net start spooler
    exit /b
	
:end
	exit 0