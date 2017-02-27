title Setting up your computer
color 0a
cls
@echo off
setlocal enableextensions enabledelayedexpansion

goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        goto begin
    ) else (
        echo Failure: this command prompt needs elevated rights to execute, please execute it again with admin rights.
        pause
        exit
    )


:begin
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

  REM Downloading dotfiles
  echo Downloading dotfiles

  if not exist dotfiles mkdir dotfiles

  FOR /F "delims=" %%i in (dotfiles.ini) do (
    set "line=%%i"
    start "Downloading Dotfile !line!" "%HomeDrive%\ProgramData\chocolatey\bin\wget.exe" -P ./dotfiles !line!
  )

  move dotfiles\* %UserProfile%

  REM Downloading apps that cannot be installed with choco
  echo Downloading manual apps

  if not exist downloads mkdir downloads

  FOR /F "delims=" %%i in (apps-manual.ini) do (
    set "line=%%i"
    start "Downloading !line!" "%HomeDrive%\ProgramData\chocolatey\bin\wget.exe" -P ./downloads !line!
  )

  cls
  echo Once all downloads finish, hit any key to install the downloaded apps
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
  echo Cleaning the house

  del /F /Q /s downloads/*
  rmdir downloads


  echo Bye!
  exit
