#Get Hostnames of all Computer objects in  OU
$Computers = Get-ADComputer -Filter * -SearchBase "OU=GPL-607,OU=SASD,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name | Sort-Object Name
$Computers = $Computers.Name

$source = "\\ad\ubdfs\its\dan\NX.lnk"
foreach ($computer in $Computers)
{
#Copy files defined in $source to destination folder on all computers in OU
Write-host "Copying to $Computer"
Copy-Item "$source" -Destination "\\$computer\C$\Users\Public\Desktop\NX.lnk" -Recurse -Verbose

}