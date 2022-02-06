.\PsExec.exe -accepteula
$computer = Read-Host "Computer name please"
.\psexec.exe -e -s -n 10 \\$computer shutdown /r /t 0