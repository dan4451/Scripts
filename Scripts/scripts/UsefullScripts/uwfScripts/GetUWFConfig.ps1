.\PsExec.exe -accepteula
$computer = Read-Host "Computer name please"
.\psexec.exe -e -s -n 10 \\$computer C:\Windows\System32\uwfmgr.exe get-config | Out-file .\UWFConfigResult.txt
.\UWFConfigResult.txt