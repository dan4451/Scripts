import-module activedirectory  
$DaysInactive = 30  #define days 
$time = (Get-Date).Adddays(-($DaysInactive)) 
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | select-object Enabled,Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv c:\OLD_Computer.csv -notypeinformation