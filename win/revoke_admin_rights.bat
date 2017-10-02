@echo off
set user=%~1
if "%user%"=="" exit 1

wmic useraccount where name='%u%' rename newname
rem delete user from admins
net localgroup Пользователи %user% /add
net localgroup Администраторы %user% /delete
rem enable UAC
reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
rem Hide admins from login view
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v Администратор /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI /v EnumerateAdministrators /t REG_DWORD /d 0 /f