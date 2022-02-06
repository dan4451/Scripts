Import-Module ActiveDirectory 

Import-Csv -Path "\\ad\ubdfs\ITS\Dan\RDP Project\FashonLabUsers.csv" | ForEach-Object {Add-ADGroupMember -Identity “RDS SASD 216 Users” -Members $_.’User-Name’}