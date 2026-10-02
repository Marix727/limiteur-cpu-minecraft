@echo off
cd /d "%~dp0"
echo Activation du XRay...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0toggle-xray.ps1" -On
echo.
echo Appuyez sur une touche pour fermer.
pause >nul
