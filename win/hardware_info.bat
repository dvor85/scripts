@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1 delims= " %%A IN ('wmic os get CSName /Format:table') DO (
	IF %%A GTR 0 (
		SET name=%%A
		SET saveto=.
		)
)

rem # Процессор: Текущая частота, модель, ID, Максимальная частота, модель процессора, статус
rem wmic cpu get CurrentClockSpeed, Caption, DeviceID,MaxClockSpeed, name, status /format:table > %saveto%\%name%.txt
wmic cpu get Name, CurrentClockSpeed  /format:table > %saveto%\%name%.txt

rem # BIOS: Название, серийник, версия
wmic bios get name, serialnumber, version /format:list >> %saveto%\%name%.txt

rem # Материнская плата: Производитель, Название, номер детали, модель, серийник
wmic baseboard get Manufacturer, product, Name, PartNumber, serialnumber /format:table >> %saveto%\%name%.txt

rem # Оперативная память: Количество слотов 
wmic memphysical get MemoryDevices /format:list >> %saveto%\%name%.txt

rem # Оперативная память: объем, слот, тип, производитель, номер детали, частота модуля
wmic memorychip get Capacity,DeviceLocator,FormFactor,Manufacturer,PartNumber,Speed /format:table >> %saveto%\%name%.txt

rem # Оперативная память: Польный объем установленной памяти
wmic computersystem get totalphysicalmemory /format:list >> %saveto%\%name%.txt

rem # Жесткий диск: 
wmic diskdrive get MediaLoaded, MediaType, Model, Name /format:table >> %saveto%\%name%.txt

rem # Жесткий диск: Описание, Тип, Файловая система, Свободно места, Буква, Метка
wmic logicaldisk get Description, DriveType, FileSystem, FreeSpace, Name, VolumeName /format:table >> %saveto%\%name%.txt

rem # Видеокарта: Производитель, объем памяти, модель
wmic path win32_videocontroller get AdapterCompatibility, AdapterRam, Caption /format:table >> %saveto%\%name%.txt

rem # Операционная система: Название, Страна, Имя ПК, Дата установки, Серийник, СервисПак, Версия, Директория установки 
wmic os get Caption, CountryCode, CSName, InstallDate, SerialNumber, ServicePackMajorVersion, Version, WindowsDirectory /format:list >> %saveto%\%name%.txt