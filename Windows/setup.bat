@echo off
setlocal enableextensions enabledelayedexpansion

REM Installing Chocolatey
echo Installing Choco

@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM Installing Apps
echo Fetching apps

set "apps="
for /f "usebackq delims=" %%a in ("apps.ini") do set "apps=!apps!%%a "

echo Installing following apps:
echo %apps%

choco install -y %apps%

REM Downloading apps that cannot be installed with choco

echo Downloading manual apps

if not exist downloads mkdir downloads

FOR /F "delims=" %%i in (apps-manual.ini) do (
  set "line=%%i"
  REM start "Downloading !line!" "C:\ProgramData\chocolatey\bin\wget.exe" -P ./downloads !line!
)

cls
echo Once all downloads finish, hit any key to install
pause

REM Installing the downloaded apps

echo Installing apps

for %%i in (downloads/*) do (
  echo Installing %%i
  start downloads/%%i
)


echo Once all instalations finish, hit any key to delete the files and end
pause

REM Cleanup

del /F /Q /s downloads/*
rmdir downloads

exit