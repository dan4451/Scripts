invoke-command -ComputerName adb-ps-01 -ScriptBlock {

# Collect port names and host addresses into hash table
$hostAddresses = @{}
Get-WmiObject Win32_TCPIPPrinterPort | ForEach-Object {
  $hostAddresses.Add($_.Name, $_.HostAddress)
}

Get-WmiObject Win32_Printer | ForEach-Object {
  New-Object PSObject -Property @{
    "Name" = $_.Name
    "DriverName" = $_.DriverName
    "HostAddress" = $hostAddresses[$_.PortName]
  }
}
}