schtasks /Create /F /RU System /SC DAILY /MO 1 /ST 00:00 /RI 10 /TN "net_stop_osppsvc" /TR "net stop osppsvc"
schtasks /Create /F /RU System /SC ONSTART /TN "nbt" /TR "nbtstat -R"
