@echo off
endlocal & setlocal EnableDelayedExpansion

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

rem gighmmpiobklfepjocnamgkkbiglidom adblock
rem cfhdojbkjhnklbpkdaibdccddilifddb adblock plus
for %%? in (
    cfhdojbkjhnklbpkdaibdccddilifddb
  ) do call:add_addon %%?
  
goto:end

:add_addon
    set addon=%~1
    echo "Install %addon%"
    set REG_PATH=HKLM\SOFTWARE\Google\Chrome\Extensions\%addon%
    if "%OS%"=="64BIT" set REG_PATH=HKLM\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\%addon%
    reg add %REG_PATH% /f /v update_url /t REG_SZ /d "https://clients2.google.com/service/update2/crx" || pause
    exit /b
    
:end