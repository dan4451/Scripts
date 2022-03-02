#DAN FRANCIA 12/6/2021
$user = $env:USERNAME
$ok = @"
                             
  ,ad8888ba,   88      a8P   
 d8"'    `"8b  88    ,88'    
d8'        `8b 88  ,88"      
88          88 88,d88'       
88          88 8888"88,      
Y8,        ,8P 88P   Y8b     
 Y8a.    .a8P  88     "88,   
  `"Y8888Y"'   88       Y8b 
"@


if($user -like "adm.*"){
Write-host "Checked that account running script is adm.`n $($ok)" -ForegroundColor Green; start-sleep -s 4;

\\server6\Shared\IT\Dan\RemoteCommandsForUs\LAPSPwd.ps1; exit

}
else{
Write-host "This script needs to be run as your adm. account." -ForegroundColor Red; start-sleep -s 10
}
exit