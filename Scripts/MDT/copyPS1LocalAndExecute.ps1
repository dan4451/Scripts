powershell.exe -WindowStyle Minimized -ExecutionPolicy Bypass -Command "Copy-Item '%DEPLOYROOT%\Applications\DisableRestore\systemrestoredisable.ps1' -destination C:\Windows\Temp;  
C:\Windows\Temp\systemrestoredisable.ps1; 
Remove-Item C:\Windows\temp\*.ps1 -Force"
