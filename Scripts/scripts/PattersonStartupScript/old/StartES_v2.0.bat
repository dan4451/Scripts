@ECHO OFF
PowerShell.exe -NoProfile -Command "& {Start-Process Powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""StartES.ps1""' -Verb RunAS}"

pause