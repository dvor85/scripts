@echo off

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT|| set OS=64BIT

set REG_PATH=HKLM\SOFTWARE\Google\Chrome\Extensions\cfhdojbkjhnklbpkdaibdccddilifddb
if "%OS%"=="64BIT" set REG_PATH=HKLM\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\cfhdojbkjhnklbpkdaibdccddilifddb

reg add %REG_PATH% /f /v update_url /t REG_SZ /d "https://clients2.google.com/service/update2/crx" || pause

