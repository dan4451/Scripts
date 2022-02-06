#Get credentials to run ES as pattersonServiceAccount

$password = Get-Content .\PR\password.txt | ConvertTo-SecureString -Key (Get-Content .\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)

$credential
$timeoutSeconds = 20

# Set the OU here with Distinguished Name

$OU = Get-ADComputer -SearchBase "OU=Respondus Lab,OU=ELI,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | -Select Name 
ForEach ($Computer In $OU ) {
    if(Test-Connection -ComputerName $Computer -Count 1 -TimeToLive $timeoutSeconds -ErrorAction 0){
	
        Write-Host $Computer.Name -ForegroundColor Green 
        Invoke-Command -ComputerName $name -Credential $credential -ScriptBlock 
           {            
           $set = new-Object -com WScript.Network
           $set.SetDefaultPrinter("ADOBE PDF")
           }


       }
      else {Write-Host "Computer not found - $Computer.name" -ForegroundColor Red
       }

}