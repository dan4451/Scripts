
Import-Module ActiveDirectory

Get-ADUser -Filter * -Properties CannotChangePassword -SearchBase “OU=Students,OU=People,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu”| where {$_.CannotChangePassword} | Set-ADUser -CannotChangePassword $False