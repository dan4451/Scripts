.\PsExec.exe -accepteula
$computer = Read-Host "Computer name please"
.\psexec.exe -e -s -n 10 \\$computer C:\Windows\System32\uwfmgr.exe filter enable
.\psexec.exe -e -s -n 10 \\$computer shutdown /r /t 0