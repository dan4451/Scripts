##################################
## Rename an array of computers ##
##################################


$Computers = @('SD-VM-DAN05','SD-LT-DAN-TEST')
$users = @('adm.dan.francia','cooltestaccount01')
$computersNewNames = @('SD-VM-DAN02','SD-LT-DAN-TEST1')

for($i = 0; $i -lt $computers.Length; $i++){
    
    $oldcompname = $Computers[$i]
    $usermsg = $users[$i]
    $newcompname = $computersNewNames[$i]
    $connectionTest = Test-Connection -BufferSize 32 -count 1 -ComputerName $oldcompname -Quiet
    $userTest = invoke-command -computername $oldcompname -Scriptblock {((Get-CimInstance Win32_ComputerSystem).username).split('\')[1]}

    try{
        $connectionTest
        if($connectionTest = $false){throw}
            $userTest
            if($userTest -ne $usermsg){throw}
                Write-Output "$oldcompname is online, changing name and sending a message."
                msg $usermsg /server:$oldcompname /time:1200 "Your computer's name has been changed. Please complete the rename process by rebooting the computer at the earliest possible convenience. Thank you."
                invoke-command -ComputerName $oldcompname -ScriptBlock{Rename-Computer -newname $using:newcompname -DomainCredential $env:USERNAME}
        }
    catch{Write-Output "$oldcompname is either offline or the user is not logged in"}
        }