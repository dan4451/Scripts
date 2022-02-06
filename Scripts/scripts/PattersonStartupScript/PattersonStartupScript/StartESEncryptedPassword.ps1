
#set location

$LocalPath = ($MyInvocation.MyCommand.Path).replace("StartESEncryptedPassword.ps1", "")

#Get credentials to run ES as pattersonServiceAccount

$password = Get-Content $LocalPath\PR\password.txt | ConvertTo-SecureString -Key (Get-Content $LocalPath\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)

$credential

Start-process powershell.exe -Credential $credential -windowstyle hidden -ArgumentList "Start-Process Eaglesoft.exe -Verb runAs"