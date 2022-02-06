foreach ($computer in Get-Content \\ad\ubdfs\its\dan\scripts\UsefullScripts\RESP-LAB.txt){
$destination = "\\$computer\c$\Users\Public\Desktop"
copy-item -Path \\ad\ubdfs\its\dan\PearsonVueTesting\CCE.exe -Destination $destination -Verbose
}