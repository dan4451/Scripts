$Enabled = 0
$disabled = 1
$WindowsUpdateRegKey = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
Set-ItemProperty -Path $WindowsUpdateRegKey -Name UseWUServer -Value $Enabled -Type DWord
Restart-Service wuauserv -Force
Enable-WindowsOptionalFeature –Online –FeatureName NetFx3 –All
Set-ItemProperty -Path $WindowsUpdateRegKey -Name UseWUServer -Value $disabled -Type DWord
Restart-Service wuauserv -Force