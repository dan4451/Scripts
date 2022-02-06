#Get credentials to run ES as pattersonServiceAccount

$LocalPath = ($MyInvocation.MyCommand.Path).replace("SetDefaultPrinterv2.ps1", "")

$password = Get-Content $LocalPath\PR\password.txt | ConvertTo-SecureString -Key (Get-Content $LocalPath\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)

$credential

# Set the OU here with Distinguished Name

$OU = "OU=Respondus Lab,OU=ELI,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu"


Get-ADComputer -Filter * -SearchBase "$OU" | select Name | foreach{

$name = $_.name


Invoke-Command -ComputerName $name -Credential $credential -ScriptBlock {


$net = new-Object -com WScript.Network
$net.SetDefaultPrinter("ADOBE PDF")


}-Verbose
} -Verbose