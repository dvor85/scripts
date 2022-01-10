@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1 delims= " %%A IN ('wmic os get CSName /Format:table') DO (
	IF %%A GTR 0 (
		SET name=%%A
		SET saveto=.
		)
)

rem # ������: ������ ����, ������, ID, ���ᨬ��쭠� ����, ������ ������, �����
rem wmic cpu get CurrentClockSpeed, Caption, DeviceID,MaxClockSpeed, name, status /format:table > %saveto%\%name%.txt
wmic cpu get Name, CurrentClockSpeed  /format:table > %saveto%\%name%.txt

rem # BIOS: ��������, �਩���, �����
wmic bios get name, serialnumber, version /format:list >> %saveto%\%name%.txt

rem # ���ਭ᪠� ����: �ந�����⥫�, ��������, ����� ��⠫�, ������, �਩���
wmic baseboard get Manufacturer, product, Name, PartNumber, serialnumber /format:table >> %saveto%\%name%.txt

rem # ����⨢��� ������: ������⢮ ᫮⮢ 
wmic memphysical get MemoryDevices /format:list >> %saveto%\%name%.txt

rem # ����⨢��� ������: ��ꥬ, ᫮�, ⨯, �ந�����⥫�, ����� ��⠫�, ���� �����
wmic memorychip get Capacity,DeviceLocator,FormFactor,Manufacturer,PartNumber,Speed /format:table >> %saveto%\%name%.txt

rem # ����⨢��� ������: ����� ��ꥬ ��⠭�������� �����
wmic computersystem get totalphysicalmemory /format:list >> %saveto%\%name%.txt

rem # ���⪨� ���: 
wmic diskdrive get MediaLoaded, MediaType, Model, Name /format:table >> %saveto%\%name%.txt

rem # ���⪨� ���: ���ᠭ��, ���, �������� ��⥬�, �������� ����, �㪢�, ��⪠
wmic logicaldisk get Description, DriveType, FileSystem, FreeSpace, Name, VolumeName /format:table >> %saveto%\%name%.txt

rem # ���������: �ந�����⥫�, ��ꥬ �����, ������
wmic path win32_videocontroller get AdapterCompatibility, AdapterRam, Caption /format:table >> %saveto%\%name%.txt

rem # ����樮���� ��⥬�: ��������, ��࠭�, ��� ��, ��� ��⠭����, ��਩���, ��ࢨᏠ�, �����, ��४��� ��⠭���� 
wmic os get Caption, CountryCode, CSName, InstallDate, SerialNumber, ServicePackMajorVersion, Version, WindowsDirectory /format:list >> %saveto%\%name%.txt