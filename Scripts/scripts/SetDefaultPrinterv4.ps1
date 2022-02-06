# OU Name
$OU = "OU=DNH-XRAY,OU=DNH,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu"
  
# Window Title
$Host.UI.RawUI.WindowTitle = "Processing Computers in OU " + $OU
 
# Connectivity Timeout
$timeoutSeconds = 20
#The window title of the PowerShell windows will display "Processing Computers in OU OU=SETOFCOMPUTERS,OU=COMPUTEROU,DC=DOMAINNAME,DC=COM" while the Connectivity Timeout variable is used later to complete inital connectivity of the computer before completing the script.
 
# Computer name list
$ComputerNames = Get-ADComputer -Filter * -SearchBase $OU | Select Name

#set credential file
$password = Get-Content .\PR\password.txt | ConvertTo-SecureString -Key (Get-Content .\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)
$credential
 
# ForEach loop to complete command on each Computer
FOREACH ($Computer in $ComputerNames) {
    if(Test-Connection -ComputerName $($Computer).Name -Count 1 -TimeToLive $timeoutSeconds -ErrorAction 0){
	
    Write-Host $Computer.Name -ForegroundColor Green 
    Enter-PSSession -ComputerName $Computer.Name -Credential $credential 

    
           $set = new-Object -com WScript.Network
           $set.SetDefaultPrinter("Adobe PDF")

           Exit-PSSession
             
    
    }
    else {Write-Host "Computer NOT FOUND $Computer.Name" -Foreground Red
    }
 
}