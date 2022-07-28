Invoke-Command -ComputerName sd-lt-tnishon {
  Set-NetFirewallRule -DisplayGroup 'Remote Event Log Management' -Enabled True -PassThru |
  Select-Object -Property DisplayName, Enabled
} -Credential (Get-Credential)