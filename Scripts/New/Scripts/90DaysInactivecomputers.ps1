$DaysInactive = 90
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))
Get-ADComputer -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true } -Properties LastLogonDate | Select-Object Name, LastLogonDate, DistinguishedName