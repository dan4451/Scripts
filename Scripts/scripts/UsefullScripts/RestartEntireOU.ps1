#RestartComputersbyOU.ps1
Import-Module ActiveDirectory
$ou = "OU=ENG-LAB-113,OU=ENG,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu"
$computers = Get-ADComputer -Filter * -SearchBase $ou
ForEach ( $c in $computers ) {
	Restart-Computer -ComputerName $c.name -Force
}