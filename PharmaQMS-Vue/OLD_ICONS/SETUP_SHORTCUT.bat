@echo off
title PharmaQMS - One-Time Setup
color 0b

echo.
echo ========================================================
echo    PHARMA-QMS ENTERPRISE - INSTALLATION
echo ========================================================
echo.
echo [1/3] Creating Desktop Shortcut...

:: PowerShell command to create shortcut
set "TARGET=%~dp0PHARMA_QMS_LAUNCHER.bat"
set "ICON=%~dp0app\dist\icons\icon-144x144.png"
set "NAME=PharmaQMS Enterprise"

powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut([System.IO.Path]::Combine($env:USERPROFILE, 'Desktop', '%NAME%.lnk')); $SC.TargetPath = '%TARGET%'; $SC.WorkingDirectory = '%~dp0'; $SC.IconLocation = '%ICON%'; $SC.Save()"

if exist "%USERPROFILE%\Desktop\%NAME%.lnk" (
    echo      [OK] Shortcut created successfully.
) else (
    echo      [ERROR] Could not create shortcut.
)

echo.
echo [2/3] Cleaning up folder...
if not exist "OLD_ICONS" mkdir "OLD_ICONS"

:: Hide the internal launcher to reduce confusion (Optional, removing 'Hidden' attribute if you want to debug)
attrib +h PHARMA_QMS_LAUNCHER.bat

:: Move any left over scripts if they exist (suppress errors)
move *.vbs OLD_ICONS\ >nul 2>&1
move START_*.bat OLD_ICONS\ >nul 2>&1
move run_*.bat OLD_ICONS\ >nul 2>&1

echo      [OK] Folder cleaned.

echo.
echo ========================================================
echo    INSTALLATION COMPLETE
echo ========================================================
echo.
echo You can now launch the application from your DESKTOP.
echo.
echo This file will now move itself to OLD_ICONS.
pause

:: Valid self-move
move "%~nx0" OLD_ICONS\
