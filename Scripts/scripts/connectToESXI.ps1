#Connects to the Hypervisor
Connect-VIServer TLB-HOST04

$name = SD-VM-DAN04
$targetVMHost = Get-VMHost -Name TLB-HOST04

#Creates a VM
New-VM -Name $name -ResourcePool $targetVMHost -Datastore TLB-Host04-DatastoreSSD -NumCpu 2 -MemoryMB 4096 -DiskGB 40 -NetworkName "DevLAN-EndPoints" -Floppy -cd -DiskStorageFormat Thin -GuestId 