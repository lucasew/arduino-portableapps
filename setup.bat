@echo off

rem cd to the folder where this script is
rem https://stackoverflow.com/questions/672693/windows-batch-file-starting-directory-when-run-as-admin
cd /d %~dp0

if not exist App\arduino\arduino.exe (
    echo Arduino not extracted in App\arduino
    color 47
    pause > nul
    exit
)

for /f %%i in ('powershell "(Get-Item -path ./App/arduino/arduino.exe).VersionInfo.ProductVersion"') do set VERSION=%%i
set DISPVERSION=%VERSION:.=%

rem for /f %%i in ('powershell ^"$env:VERSION.Replace(^".^", ^"^")^"') do set DISPVERSION=%%i

(
echo # Dont change information here cause it will be overwritten using setup.cmd
echo [Version]
echo PackageVersion=%VERSION%
echo DisplayVersion=%DISPVERSION%
echo [Format]
echo Type=PortableApps.comFormat
echo Version=3.5
echo [Details]
echo Name=Arduino IDE
echo AppID=Arduino
echo "Publisher=lucas59356@gmail.com & PortableApps.com"
echo Homepage=arduino.cc
echo Category=Development
echo Description=Arduino IDE
echo Language=English
echo [License]
echo Shareable=true
echo OpenSource=true
echo Freeware=true
echo CommercialUse=true
echo [Control]
echo Icons=1
echo Start=App\arduino\arduino.exe
) > App\AppInfo\appinfo.ini

pushd App\arduino
net session 1>nul 2>nul
if %errorLevel% == 0 (
    color 27
) else (
    echo You are not a admin
    color 47
    pause > nul
    exit
)
echo Creating symlink to data
mklink /D portable ..\..\Data
popd

pause >nul