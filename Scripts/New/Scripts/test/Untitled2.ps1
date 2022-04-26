$computers = @()
$computersNewName = @()
$toTest = Import-csv 'C:\Users\daniel.francia\OneDrive - Maravai Life Sciences, Inc\Documents\ComputersToRenametest.csv' | ForEach-Object {
$computers += $_.OldName
$computersNewName += $_.NewName
}


function Main (){
for($i = 0; $i -lt $computers.length; $i++){
$testConnect = Test-Connection $computers[$i] -verbose -Count 1 -quiet
$compname = $Computers[$i]
$computerNameTest = Get-ADComputer $computersNewName[$i] -Verbose
$userTest = invoke-command -computername $computers[$i] -Scriptblock {((Get-CimInstance Win32_ComputerSystem).username).split('\')[1]}

try{
        if($testConnect -eq $true){throw "2"}
            if($testConnect -eq $false){throw "3"}
        
    
    }catch{
        if ($_.Exception.Message -eq 2){
            Write-host "$compname is online"-ForegroundColor Yellow
            }
        if($_.Exception.Message -eq 3){
            Write-host "$compname is offline"-ForegroundColor Red
         }    
    }

}
}
function CheckForNameInAD(){
    for($i = 0; $i -lt $computers.length; $i++){
        try{
            $computerNameTest = Get-ADComputer $computersNewName[$i] -Verbose
                if($computerNameTest){throw "1"}
                else{
                Main
                }
            }
        catch{
            if ($_.Exception.Message -eq 1){
                Write-Host $computerNameTest.Name is in AD already. -ForegroundColor Magenta
            }
        }
    }
}

CheckForNameInAD