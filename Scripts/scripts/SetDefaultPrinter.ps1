#Get credentials to run ES as pattersonServiceAccount

$password = Get-Content .\PR\password.txt | ConvertTo-SecureString -Key (Get-Content .\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)

$credential


Invoke-Command -ComputerName DNH-OPT-01 -Credential ad\dfrancia -ScriptBlock{


$Printername="Adobe PDF"
$DefaultPrinter=Get-WmiObject win32_Printer -Filter "Name='$Printername'"
$DefaultPrinter.setDefaultPrinter()


}
