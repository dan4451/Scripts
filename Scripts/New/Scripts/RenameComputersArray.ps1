##################################
## Rename an array of computers ##
##################################

#Set credentials in a secure string. This credential is used to initiate the name change.
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user domain admin username and password.", "$env:username", "NetBiosUserName")

#initialize arrays
$Computers = @()
$computersNewNames = @()

#populate arrays with data from csv
Import-csv 'C:\Users\daniel.francia\OneDrive - Maravai Life Sciences, Inc\Documents\ComputersToRenameTest.csv' | ForEach-Object {
    $computers += $_.OldName
    $computersNewNames += $_.NewName
}
#Main Method
#start the for loop that will run through the array. The variable "i" increases by 1 every loop.
#The for loop will run until "i" reaches the same value of the length of the array.
#the method will test connection to the computer, if a user is logged in, it will proceed to send that user a message in a pop up and then rename the computer.
for($i = 0; $i -lt $computers.Length; $i++){
    
    $oldcompname = $Computers[$i]
    $newcompname = $computersNewNames[$i]
    $connectionTest = Test-Connection -BufferSize 32 -count 1 -ComputerName $oldcompname -Quiet
    $userTest = invoke-command -computername $oldcompname -Scriptblock {((Get-CimInstance Win32_ComputerSystem).username).split('\')[1]}


    try{        
        if($connectionTest -eq $false){throw}
            if($userTest -eq $null){throw}
            else{
                Write-Output "$oldcompname is online, changing name and sending a message."
                msg $userTest /server:$oldcompname /time:1200 "Your computer's name has been changed. Please complete the rename process by rebooting the computer at the earliest possible convenience. Thank you."
                invoke-command -ComputerName $oldcompname -ScriptBlock{Rename-Computer -newname $using:newcompname -DomainCredential $using:credential}
                }
        }
    catch{Write-Output "$oldcompname is either offline or the user is not logged in"}
        }