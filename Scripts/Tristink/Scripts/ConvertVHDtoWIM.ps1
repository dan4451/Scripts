#set the VHD mount folder
$Mount="g:\mount"
#create a folder g:\mount
Mkdir $Mount

#mount the c:\temp\VHDNAME.vhd to $Mount folder
Mount-WindowsImage -ImagePath "\\labfs\Shared\Thermo-Backup\WindowsImageBackup\SDI-DT-2Q9X2G3\Backup 2022-02-07 195232\90534929-7045-4423-9286-94582b543453.vhdx" -Path "$Mount" -Index 1

#Create new Wim image to c:\temp\VHDNAME.wim folder
New-WindowsImage -CapturePath "$Mount" -Name "Thermo" -ImagePath "g:\capture\Thermo.wim" -Description "Thermo" -Verify

#dismount  the $Mount folder
Dismount-WindowsImage -Path "$Mount" -Discard