$directory = "C:\Windows\Temp\DriversFor7420\"
$package = "\\tlb-it02\DeploymentShare$\PDQ\Drivers\7420\7420.zip"

if (Test-Path $directory) {
Write-host "Directory exists"
}
else{
New-Item $directory -ItemType Directory 
}

Copy-Item  $package $directory -Force
Expand-Archive $directory\7420.zip $directory  -Verbose

C:\Windows\Temp\DriversFor7420\Intel-Thunderbolt-Controller-Driver_TBTC0_WIN_1.41.1193.0_A11.EXE /s /l "C:\Windows\Temp\ThunderboltDriverInstallLog.txt"
C:\Windows\Temp\DriversFor7420\Intel-Chipset-Device-Software_NNRNY_WIN_10.1.18460.8229_A13_02.EXE /s /l "C:\Windows\Temp\ChipsetDriverInstallLog.txt"
C:\Windows\Temp\DriversFor7420\Intel-Management-Engine-Components-Installer_63VJG_WIN64_2218.2.2.0_A08_01.EXE /s /l "C:\Windows\Temp\MEDriverInstallLog.txt"
C:\Windows\Temp\DriversFor7420\Intel-Serial-IO-Driver_55PHH_WIN_30.100.2104.1_A01_02.EXE /s /l "C:\Windows\Temp\SerialIODriverInstallLog.txt"
C:\Windows\Temp\DriversFor7420\Realtek-USB-Audio-DCH-Driver_KDGRR_WIN_6.3.9600.2299_A20_02.EXE /s /l "C:\Windows\Temp\USBAudioDriverInstallLog.txt"
C:\Windows\Temp\DriversFor7420\Realtek-USB-GBE-Ethernet-Controller-Driver_3K7FF_WIN_1153.6.0418.2022_A27_01.EXE /s /l "C:\Windows\Temp\USBEthernetControllerDriverInstallLog.txt"


Remove-Item C:\Windows\Temp\DriversFor7420 -Force -Recurse