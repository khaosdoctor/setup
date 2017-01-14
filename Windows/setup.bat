@echo off
setlocal enableextensions enabledelayedexpansion

REM Installing Chocolatey
echo Installing Choco

@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM Installing Apps
echo Fetching apps
set /p apps=<apps.ini

echo Installing following apps:
echo %apps%

choco install -y %apps%