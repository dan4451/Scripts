#Get Hostnames of all Computer objects in  OU
$Computers = Get-ADComputer -Filter * -SearchBase "OU=ENG-LAB-163,OU=ENG,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name | Sort-Object Name
$Computers = $Computers.Name


foreach ($computer in $Computers)
{
#Deletes cache of computers in Distinguished Name
invoke-command -ComputerName $computer -ScriptBlock {

## Initialize the CCM resource manager com object
[__comobject]$CCMComObject = New-Object -ComObject 'UIResource.UIResourceMgr'
## Get the CacheElementIDs to delete
$CacheInfo = $CCMComObject.GetCacheInfo().GetCacheElements()
## Remove cache items
ForEach ($CacheItem in $CacheInfo) {
    $null = $CCMComObject.GetCacheInfo().DeleteCacheElement([string]$($CacheItem.CacheElementID))
}
}

}