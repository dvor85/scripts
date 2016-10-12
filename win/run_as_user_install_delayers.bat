taskkill /f /IM delayers.exe
set delayers=%APPDATA%\delayers\
mkdir %delayers%
copy /B /Y \\engarde\delay\delayers.exe %delayers%
copy /B /Y \\engarde\delay\delayers.ini %delayers%
start %delayers%\delayers.exe /install


