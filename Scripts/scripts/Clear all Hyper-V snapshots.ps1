Invoke-Command -ComputerName adb-DRVM-01 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-DRVM-01 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-DRVM-02 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-DRVM-02 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-itvm-02 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-itvm-02 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-itvm-03 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-itvm-03 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-itvm-03 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-itvm-03 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-801 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-801 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-802 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-802 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-913 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-913 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-914 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-914 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
 Invoke-Command -ComputerName adb-HV-915 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-915 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-916 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-916 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
Invoke-Command -ComputerName adb-HV-917 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-917 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
 Invoke-Command -ComputerName adb-HV-918 -ScriptBlock {get-vm | get-vmsnapshot | select Name}
 Invoke-Command -ComputerName adb-HV-918 -ScriptBlock {get-vm | get-vmsnapshot | select Name | Remove-VMCheckpoint}
 ##################################################################################################
