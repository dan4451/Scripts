$path = Read-Host "Enter path"


Get-ChildItem -Path $path -Recurse -ErrorAction Continue -Filter *.vhdx | ForEach-Object -Verbose {


#Param([string]$Path = $(Throw '-Path is required'))
Echo "Attempting to Mount $Path$_.name"
Mount-vhd $_.FullName -readonly
Echo "Attempting to compact $Path"
Optimize-vhd $_.FullName -mode full
Echo "Attempting to dismount $Path"
Dismount-vhd $_.FullName

}
