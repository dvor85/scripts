@echo off
set user=%~1
if "%user%"=="" exit 1

wmic useraccount where name='%username%' rename %user%
