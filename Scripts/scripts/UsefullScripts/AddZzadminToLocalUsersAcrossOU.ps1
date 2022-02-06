#Get Hostnames of all Computer objects in  OU
$Computers = Get-ADComputer -Filter * -SearchBase "OU=ABC-MUSIC-LAB,OU=MUSIC,OU=ART,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | Select Name | Sort-Object Name
$Computers = $Computers.Name



foreach ($computer in $Computers){

Invoke-command -computername $computer -Verbose -ScriptBlock  {

function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
        Write-Verbose "$NewLocalAdmin local user crated"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }    
    end {
    }
}
$NewLocalAdmin = "zzadmin"
$Password = Read-Host -AsSecureString "Create a password for $NewLocalAdmin"
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password -Verbose


} 
}