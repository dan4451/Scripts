Get-ADComputer -Filter * -SearchBase "OU=Respondus Lab,OU=ELI,OU=Student,OU=CAS,OU=Org,OU=UBROOT,DC=ad,DC=bridgeport,DC=edu" | select Name | foreach{
    $name = $_.name

    New-PSSession $name | Enter-PSSession -Verbose



#Gets A List Of Printers
#-----------------------

$printers1 = Get-childitem -Path HKCU:\printers\connections | select name
$printers2 = $printers1 -replace '.*,,'
$printers3 = $printers2 -replace ',','\'
$printers = $printers3 -replace '}', ''

#------------------------------------------------------
#To Replace The Old Print Server Name With The New One
#------------------------------------------------------

$newprinters = $printers -replace 'adb-ps-02','\\adb-ps-01'

#--------------------
#Gets Default Printer
#--------------------

$default = Get-itemproperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" | select device
$default1 = $default -replace '.*='
$default2 = $default1 -replace '()'
$default3 = $default2 -replace ',winspool'
$defaultprinter = $default3 -replace ',.*'

#------------------------------------------------------
#To Replace The Old Print Server Name With The New One
#------------------------------------------------------

$newdefaultprinter = $defaultprinter -replace 'adb-ps-02','\\adb-ps-01'

#------------------------
#Deletes The Old Printers
#------------------------

#Get-WMIObject Win32_Printer | where{$_.Network -eq 'true'} | foreach{$_.delete()}

Exit-PSSession

}





