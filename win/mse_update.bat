@echo off
set MSE=("%ProgramFiles%\Microsoft Security Client\MpCmdRun.exe","%ProgramFiles%\Windows Defender\MpCmdRun.exe")
for %%? in %MSE% do ( 
  if exist %%? (
    schtasks /Create /F /SC DAILY /MO 1 /ST 08:00 /RI 60 /DU 24:00 /RL HIGHEST /RU System /TN "MSE Update" /TR "'%%~?' -SignatureUpdate -ScheduleJob -RestrictPrivileges"
  )
)