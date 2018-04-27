@echo off
set old_user=%~1
set new_user=%~2
if "%new_user%"=="" exit 1

wmic useraccount where name='%old_user%' rename '%new_user%'
