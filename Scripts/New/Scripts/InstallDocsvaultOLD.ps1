$TrueHash = "AF2EBDD6FC023B33938E622ACF9BF3AD21A0E494DC6BD84323CA14FAC926B500"
$Hash = Get-FileHash "C:\Program Files (x86)\Docsvault SB\Client\dvclient.exe"
$ReportedHash = $Hash.Hash
$test = Test-Path -Path "C:\Program Files (x86)\Docsvault SB\Client\dvclient.exe"
if($Hash = $null){exit}
else{
    if($ReportedHash -ne $TrueHash){

    get-process -name explorer | Stop-Process -Force
    msiexec /i "\\trilinksd.local\SysVol\trilinksd.local\Apps\Docsvault_SB_Client_v13.5.msi" /quiet
    }
}