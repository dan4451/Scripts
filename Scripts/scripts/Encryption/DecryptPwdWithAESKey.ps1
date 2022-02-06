$PasswordFile = "\\ad\ubdfs\ITS\Shared\Software\CGM\CGMStartupScript\PR\password.txt"

$keyFile = "\\ad\ubdfs\ITS\Shared\Software\CGM\CGMStartupScript\PR\aes.key"

$key = Get-Content $KeyFile

$MyPassword = Get-Content $PasswordFile | ConvertTo-SecureString -Key $key

$Marshal = [System.Runtime.InteropServices.Marshal]
$BSTR = $Marshal::SecureStringToBSTR($MyPassword)
$password = $Marshal::PtrToStringAuto($BSTR)