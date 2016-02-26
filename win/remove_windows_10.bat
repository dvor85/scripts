@echo off
for %%? in (
    "3080149"
    "3075249"
    "2952664"
    "3035583"
    "3068708"
    "3022345"
    "3021917"
    "2976978"
    "3044374"
    "2990214"
    "971033"
    "3075851"
    "3065988"
    "3083325"
    "3083324"
    "3075853"
    "3065987"
    "3050265"
    "3050267"
    "3046480"
  ) do ( start /wait wusa /uninstall /norestart /quiet /kb:%%~? && echo KB%%~? UNINSTALL SUCCSESS || echo KB%%~? UNINSTALL FAIL)
pause
