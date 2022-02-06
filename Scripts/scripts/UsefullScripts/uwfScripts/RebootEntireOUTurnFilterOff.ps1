# Set the OU here with Distinguished Name

$OU = "OU=BUS_SP_LAB,OU=BUS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu"


Get-ADComputer -Filter * -SearchBase "$OU" | select Name | foreach{

$name = $_.name


Invoke-Command -ComputerName $name -ScriptBlock {

    # display computername

    hostname

    # disable filter

    uwfmgr.exe filter disable

    # gets filter state and assigns to a  variable

    # $NAMESPACE = "root\standardcimv2\embedded"
    # $objUWFInstance = Get-WMIObject -namespace $NAMESPACE -class UWF_Filter
    
    #display filter state

    # $objUWFInstance

    # reboot the PC so it restarts with filter off

    Shutdown -r -t 1

                                                }

                                                                    }