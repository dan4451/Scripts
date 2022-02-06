# Set the OU here with Distinguished Name

$OU = "OU=Respondus Lab,OU=ELI,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu"


Get-ADComputer -Filter * -SearchBase "$OU" | select Name | foreach{

$name = $_.name


Invoke-Command -ComputerName $name -ScriptBlock {
    $NAMESPACE = "root\standardcimv2\embedded"
    $objUWFInstance = Get-WMIObject -namespace $NAMESPACE -class UWF_Filter
    
    $objUWFInstance

    }

    

 }
