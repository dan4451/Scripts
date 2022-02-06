
#set location

$LocalPath = ($MyInvocation.MyCommand.Path).replace("StartFNEncryptedPassword.ps1", "")

#Get credentials to run Figurenotes as zzadmin

$password = Get-Content $LocalPath\PR\password.txt | ConvertTo-SecureString -Key (Get-Content $LocalPath\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("zzadmin",$password)

$credential

Start-process powershell.exe -Credential $credential -windowstyle hidden -ArgumentList "Start-Process figurenotes.exe -Verb runAs"