Import-Module ActiveDirectory
$softwareFolders = Get-ChildItem "\\its-dan\g$\Matlab\Temp\Matlab.zip"<#"\\ad\ubdfs\ITS\DeploymentShare\Lab Software\SASD\Autodesk\Revit 2021"#> -Directory
$Computers = Get-ADComputer -Filter * -SearchBase "OU=ENG-LAB-111,OU=ENG,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name
$Computers = $Computers.Name
foreach ($pc in $computers) {
    foreach ($sw in $softwareFolders) {

     Write-host $pc
    Test-path -Path "\\$pc\c$\Temp\Matlab.zip"
   
    #    Copy-Item -Path "\\its-dan\g$\Matlab\Matlab.zip"  -Destination "\\$pc\c$\Temp\Matlab.zip" -Force -Recurse -verbose
   #     Expand-Archive \\$pc\c$\Temp\matlab.zip \\$pc\c$\Temp\matlabExracted        
    #    Enter-PSSession -ComputerName $pc
     #   Start-Process "C:\Temp\matlabExracted\Matlab 2021\Shared PC\R2021a\installMatlab.bat" -Wait -Verb Runas
      #  Exit-PSSession
       # Remove-Item \\$pc\c$\Temp\matlab.zip -Force -Recurse -verbose
       # Invoke-Command –ComputerName $pc –ScriptBlock {Start-Process "C:\Temp\matlabExtracted\Matlab final\Matlab 2021\Shared PC\R2021a\installMatlab.bat" -Wait} -verbose
    }
}