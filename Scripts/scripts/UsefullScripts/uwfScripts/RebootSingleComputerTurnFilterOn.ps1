Invoke-Command -ComputerName RESP-LAB-02 -ScriptBlock {

    #set filter

    uwfmgr.exe filter enable

    # gets filter state and assigns to a  variable

    # $NAMESPACE = "root\standardcimv2\embedded"
    # $objUWFInstance = Get-WMIObject -namespace $NAMESPACE -class UWF_Filter
    
    # display filter state

    # $objUWFInstance

    # reboot the PC so it restarts with filter on

    Shutdown -r -t 1

                                                }