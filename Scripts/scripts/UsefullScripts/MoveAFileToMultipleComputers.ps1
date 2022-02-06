#useV2 script


#Point the script to the text file
$Computers = "\\ad\ubdfs\its\dan\scripts\UsefullScripts\uwfScripts\SASD-GPL.txt"

# sets the varible for the file location ei c:\temp\ThisFile.exe
$Source = "\\ad\ubdfs\its\dan\SASD\Revit.ini"

# sets the varible for the file destination
$Destination = "windows\ProgramData\Autodesk\RVT 2019\userdatacache\"

# displays the computer names on screen
Get-Content $Computers | foreach {Copy-Item -Path $Source -Destination "\\$env:computername\c$\$Destination"}