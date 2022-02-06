#--------------------------
#Set Execution Of PSScripts
#--------------------------

Set-ExecutionPolicy Unrestricted -force

#------------
#Turn Off UAC
#------------

New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

#------------------------------
#Enter The Name Of The Computer
#------------------------------

#$comp = "NAME HERE"

#or if you wish to be prompted for the computer name

$comp = Read-host 'Enter the name of the computer?'

#---------------------------------------
#Starts WinRM Service On Remote Computer
#---------------------------------------

Import-Module Remote_PSRemoting -force
Set-WinRMListener -computername $comp
Restart-WinRM -computername $comp
Set-WinRMStartUp -computername $comp

Start-Sleep -Seconds 60

#----------------------------------------------
#Establish a PSSession With The Remote Computer
#----------------------------------------------

New-PSSession $comp | Enter-PSSession

#All of the replace commands are used to strip the extra characters and just #give a \\server\printer path return
#-----------------------
#Gets A List Of Printers
#-----------------------

$printers1 = Get-childitem -Path HKCU:\printers\connections | select name
$printers2 = $printers1 -replace '.*,,'
$printers3 = $printers2 -replace ',','\'
$printers = $printers3 -replace '}', ''

#------------------------------------------------------
#To Replace The Old Print Server Name With The New One
#------------------------------------------------------

$newprinters = $printers -replace 'oldserver','\\newserver'

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

$newdefaultprinter = $defaultprinter -replace 'oldserver','\\newserver'

#------------------------
#Deletes The Old Printers
#------------------------

Get-WMIObject Win32_Printer | where{$_.Network -eq 'true'} | foreach{$_.delete()}

#----------------------------------------
#Exits PSSession With The Remote Computer
#----------------------------------------

Exit-PSSession

#-----------
#Turn UAC On
#-----------

#Value = 0 through 4 depending on the level of UAC

New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 2 -Force

#------------------------------------
#Turn Off Execution Policy Of Scripts
#------------------------------------

Set-ExecutionPolicy undefined -Force

#####This is as far as I could get with it. I always turn off UAC and Enable Scripts in the beginning and turn them back on ant the end.  The summary of this script will give you the new network Printer paths and the users default printers.  It also deletes the users old network printers. With powershell versions before windows 8 and server 2012, you would have to create a logon script to add the new printers and mark the default printer using WMI commands.  Use could also use a csv file with a list of computer names as an input if you wish to run this command on multiple computers.  It would look something like...


#$csv = Import-csv -Path pathofcsvfile
#foreach ($line in $csv) {

#With a bracket at the end to run through each computer in the list...