@echo off
powershell -ExecutionPolicy RemoteSigned -NoLogo -Noninteractive -Command "try { Set-NetConnectionProfile -Name %1% -NetworkCategory Private; } catch { Get-NetConnectionProfile; }"