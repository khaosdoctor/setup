title Setting up your computer
color 0a
cls
@echo off
@setlocal enableextensions enabledelayedexpansion
@cd /d "%~dp0"

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

  choco install -y --ignore-checksums %apps%

  REM Downloading dotfiles
  echo Downloading dotfiles

  if not exist dotfiles mkdir dotfiles

  FOR /F "delims=" %%i in (dotfiles.ini) do (
    set "line=%%i"
    start "Downloading Dotfile !line!" "%HomeDrive%\ProgramData\chocolatey\bin\wget.exe" -P ./dotfiles !line!
  )

  REM Moving dotfiles to the right place
  move dotfiles\* %UserProfile%

  REM Starting configuration
  echo I'll ask you some questions now
  set /p gituser=What is your git username? 
  set /p gitmail=What is your git email?

  start git config --global user.name "%gituser%"
  start git config --global user.email "%gitmail%"
  start git config --global core.autocrlf true
  start git config --global rerere.enabled true
  start git config --global apply.whitespace nowarn
  start git config --global core.excludesfile "%UserProfile%\.gitexcludes"

  REM Downloading Yarn packages
  echo Downloading yarn packages
  set "yapps="
  for /f "usebackq delims=" %%a in ("../Global/yarn.ini") do set "yapps=!yapps!%%a "
  start yarn global add %yapps%

  REM Downloading gems
  echo Installing gems
  set "gems="
  for /f "usebackq delims=" %%a in ("../Global/gems.ini") do set "gems=!gems!%%a "
  start gem install %gems% --no-ri --no-doc --source http://rubygems.org

  REM Downloading apps that cannot be installed with choco
  echo Downloading manual apps

  if not exist downloads mkdir downloads

  FOR /F "delims=" %%i in (apps-manual.ini) do (
    set "line=%%i"
    start "Downloading !line!" "%HomeDrive%\ProgramData\chocolatey\bin\wget.exe" -P ./downloads !line!
  )

  echo Once all downloads finish, hit any key to install the downloaded apps
  cls
  pause

  REM Installing the downloaded apps
  echo Installing apps

  for %%i in (downloads/*) do (
    echo Installing %%i
    start downloads/%%i
  )

  REM Composer
  echo Installing composer packages
  start composer global require "laravel/installer"

  REM Docker Images
  echo Pulling Docker images to mount databases

  start docker pull redis
  start docker pull mongo
  start docker pull mysql
  start docker pull postgres

  REM Cleanup
  echo Once all instalations finish, hit any key to delete the files
  pause
  echo Cleaning the house

  del /F /Q /s downloads\*
  rmdir downloads

  del /F /Q /s dotfiles\*
  rmdir dotfiles

  echo Setup completed
