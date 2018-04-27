@echo off
set user=%~1
if "%user%"=="" exit 1
net localgroup Пользователи %user% /add
net localgroup Администраторы %user% /delete

