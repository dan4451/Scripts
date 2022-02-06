<#	
	.SYNOPSIS
		Get Collection Information from Collection ID
	
	.DESCRIPTION
		A detailed description of the Get-SCCMCollectionInfoFromID function.
	
	.EXAMPLE
				Get-SMSCollectionInfoFromID
	.EXAMPLE
				(Get-SCCMCollectionInfoFromID).Name
	.EXAMPLE
				Get-SMSCollectionInfoFromID | gm
 .NOTES Created by: Fredrik Wall 
              Blog: http://www.fredrikwall.se
#>
function Get-SCCMCollectionInfoFromID
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True)]
		$SiteServer,
		[Parameter(Mandatory = $True)]
		$SiteCode,
		[Parameter(Mandatory = $True)]
		$CollectionID
	)
	
	$Collection = Get-WmiObject -Namespace "root\SMS\Site_$SiteCode" -Query "select * from SMS_Collection Where SMS_Collection.CollectionID='$CollectionID'" -computername $SiteServer
	$Collection
}