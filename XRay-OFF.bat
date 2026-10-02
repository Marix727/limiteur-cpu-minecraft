@echo off
cd /d "%~dp0"
echo Desactivation du XRay...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0toggle-xray.ps1" -Off
echo.
echo Appuyez sur une touche pour fermer.
pause >nul
