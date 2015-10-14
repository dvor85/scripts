set MSE=%ProgramFiles%\Microsoft Security Client\MpCmdRun.exe
if exist "%MSE%" (
	schtasks /Create /SC DAILY  /MO 1 /ST 08:00 /RI 60 /DU 24:00 /RL HIGHEST /ru System /TN "MSE Update" /TR "\"%MSE%\" SignatureUpdate -ScheduleJob -RestrictPrivileges"
)