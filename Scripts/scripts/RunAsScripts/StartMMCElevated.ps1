
#Get credentials to run program as chosen account

$password = Get-Content password.txt | ConvertTo-SecureString -Key (Get-Content aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\dan-priv",$password)

$credential

Start-process powershell.exe -Credential $credential -windowstyle hidden -ArgumentList "mmc.exe"