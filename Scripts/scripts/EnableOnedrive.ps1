#re-enable sync service
Get-Service OneSyncSvc -erroraction silentlycontinue | set-service -startuptype manual | start-service

#Re-enable usage of OneDrive
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 0 /F
Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 0 /F

#Re-enable Onedrive @ startup
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 020000000000000000000000 /F