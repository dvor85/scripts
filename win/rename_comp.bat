@echo off
set new_comp=%~1
if "%new_comp%"=="" exit 1
WMIC computersystem where caption="%computername%" rename "%new_comp%"