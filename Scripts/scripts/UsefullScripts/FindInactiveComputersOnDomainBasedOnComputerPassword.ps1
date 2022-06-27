Import-Module activedirectory
[int]$ComputerPasswordAgeDays = 90
IF ((test-path “c:\temp”) -eq $False) { md “c:\temp” }
$ExportFile = “c:\temp\InactiveWorkstations.csv”
$ComputerStaleDate = (Get-Date).AddDays(-$ComputerPasswordAgeDays)
$InactiveWorkstations = Get-ADComputer -filter { (passwordLastSet -le $ComputerStaleDate) -and (OperatingSystem -notlike “*Server*”) -and (OperatingSystem -like “*Windows*”) } -properties Name, DistinguishedName, OperatingSystem,OperatingSystemServicePack, passwordLastSet,LastLogonDate,Description
$InactiveWorkstations | export-csv $ExportFile