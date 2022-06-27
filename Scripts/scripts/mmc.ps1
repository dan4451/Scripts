cd c:\
Start-Process powershell -Credential 'trilinksd.local\adm.dan.francia' -ArgumentList '-noprofile -command &{Start-Process mmc.exe -verb runas}'