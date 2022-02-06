$siteServer = 'adb-its-02'
$siteCode = 'ADM'

Get-WmiObject -ComputerName $SiteServer -Namespace root\SMS\site_$Sitecode -Class SMS_Application | Where-Object -FilterScript {
    $_.IsLatest -eq $True} | Select-Object -Property LocaliZedDisplayName, CI_UniqueID