$DPName = "adb-ds-01.ad.bridgeport.edu"
$PkgID = "ADM0052B"

# ======= Do Not Modify The Below ======= #
$creds = Get-Credential

#remove From WMI
Get-WmiObject -ComputerName $DPName -Namespace Root\SCCMDP -Class SMS_PackagesInContlib -Filter "PackageID = '$PkgID'" | Remove-WmiObject

#remove from content library
$Contentlib = Invoke-Command -ComputerName $DPName -Credential $creds -ScriptBlock{
(Get-ItemProperty HKLM:SOFTWARE\Microsoft\SMS\DP).ContentLibraryPath
}
$driveletter = $ContentLib[0]
$location = "\\" + $DPName + "\$driveletter$\sccmcontentlib\pkglib"
Set-Location $Location
remove-item "$PkgID.INI"
Set-Location $env:SystemDrive
write-host "Done! $PkgID was removed from both WMI and Content Library on $DPName" -ForegroundColor Yellow