$computers = @()
$computersNewName = @()
$toTest = Import-csv 'C:\Users\daniel.francia\OneDrive - Maravai Life Sciences, Inc\Documents\ComputersToRenametest.csv' | ForEach-Object {
$computers += $_.OldName
$computersNewName += $_.NewName
}


for($i = 0; $i -lt $computers.length; $i++){
$testConnect = Test-Connection $computers[$i] -verbose -Count 1 -quiet
$compname = $Computers[$i]
$computerNameTest = Get-ADComputer $computersNewName[$i] -Verbose
$userTest = invoke-command -computername $computers[$i] -Scriptblock {((Get-CimInstance Win32_ComputerSystem).username).split('\')[1]}

try{
    if($computerNameTest){throw "1"}
        if($testConnect -eq $true){throw "2"}
            if($testConnect -eq $false){throw "3"}
        
    
    }catch{
        if ($_.Exception.Message -eq 1){
            Write-Host $computerNameTest.Name is in AD already. -ForegroundColor Magenta
            }
        if ($_.Exception.Message -eq 2){
            Write-host "$compname is online"-ForegroundColor Yellow
            }
        if($_.Exception.Message -eq 3){
            Write-host "$compname is offline"-ForegroundColor Red
         }

}
}