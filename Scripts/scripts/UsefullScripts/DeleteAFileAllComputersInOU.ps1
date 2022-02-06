#Get Hostnames of all Computer objects in  OU
$Computers = Get-ADComputer -Filter * -SearchBase "OU=ENG-LAB-113,OU=ENG,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name | Sort-Object Name
$Computers = $Computers.Name


foreach ($computer in $Computers)
{
#Copy files defined in $source to destination folder on all computers in OU
Write-host "Deleting file on $Computer"
Remove-Item  -Path "\\$computer\C$\Windows\System32\GroupPolicy\Machine\policy\Registry.pol" -Recurse -Verbose

}