foreach ($computer in Get-Content \\ad\ubdfs\its\dan\scripts\UsefullScripts\RESP-LAB.txt){
$destination = "\\$computer\c$\users\public\desktop"
copy-item -Path '\\ad\ubdfs\its\DeploymentShare\Testing\Pearson\CCE.exe' -Destination $destination -Recurse -Verbose
}