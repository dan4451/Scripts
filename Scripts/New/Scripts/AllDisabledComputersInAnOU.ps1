#use -searchscope after OU to define whether or not to search sub-OU's
$computers = Get-ADComputer -Filter {Enabled -ne $true} -SearchBase "OU=Org,OU=Computers,OU=TriLinkSD,DC=trilinksd,DC=local"  | Select Name

$computers.Count