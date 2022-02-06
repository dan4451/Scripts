$softwareFolders = Get-ChildItem "\\ad\ubdfs\ITS\DeploymentShare\Lab Software\SASD\Autodesk\Revit 2021" -Directory
$Computers = Get-ADComputer -Filter * -SearchBase "OU=SPL-507,OU=SASD,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name
$Computers = $Computers.Name
foreach ($pc in $computers) {
    foreach ($sw in $softwareFolders) {
        Copy-Item -Path $sw.FullName  -Destination "\\$pc\c$\Windows\Temp" -Force -Recurse -verbose
        Invoke-Command –ComputerName $pc –ScriptBlock {"C:\Windows\Temp\$($using:sw.Name)\install.bat"} -verbose
    }
    #Remove-Item -Path "\\$pc\c$\Windows\Temp" -Recurse -Force
}