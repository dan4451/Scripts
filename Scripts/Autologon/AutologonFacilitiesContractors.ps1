#autologon script for deployment
#Dan Francia


#disable file downloaded from internet security warning
$env:SEE_MASK_NOZONECHECKS = 1

#Copy to temp
copy-item \\trilinksd.local\SYSVOL\trilinksd.local\scripts\Autologin\Facilites\Autologon.cmd C:\Windows\Temp\ -Force
copy-item \\trilinksd.local\SYSVOL\trilinksd.local\Apps\Sysinternals\AutoLogon\Autologon.exe c:\Windows\Temp\ -Force
Start-Sleep 10

#run Autologon
C:\Windows\Temp\Autologon.cmd

#re-enable downloaded from internet security warning
Remove-Item env:SEE_MASK_NOZONECHECKS

#delete temp folder
Start-Sleep 10
Remove-Item c:\Windows\Temp\Autologon.exe -Force
Remove-Item C:\Windows\Temp\Autologon.cmd -Force
