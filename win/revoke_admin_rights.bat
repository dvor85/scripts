@echo off
set user=%~1
if "%user%"=="" exit 1
net localgroup ���짮��⥫� %user% /add
net localgroup ������������ %user% /delete

