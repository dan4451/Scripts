====================================================================================================================================
============================-------Launch Patterson Eaglesoft as Local Administrator Account-------=================================
======================--------------------An Explanation of its Contents Step By Step---------------------==========================
===================================================-----Dan Francia 2/20/19-----====================================================
====================================================================================================================================
--- Quick and easy: After ES install, Drop Patterson Eaglesoft.ink on public desktop and copy the entire PattersonStartupScript
folder into c:\windows\system32. Login as Pattersonserviceacco to create a profile. Add Pattersonserviceacco to local administrators (this happens in clinic as GPO). Done. 
====================================================================================================================================
1.Shortcut is Executed
====================================================================================================================================

The desktop shortcut is scripted to run StartESEncryptedPassword.ps1. Set the path in the shortcut's properties.




====================================================================================================================================
2.StartESEncryptedPassword.ps1
====================================================================================================================================
*This code retrieves a password from an encrypted file called password.txt. It can only be unlocked with it's associated AES key. When the password is acquired it is stored, still encrypted, in a secure string to be passed as a password for the local eaglesoft service account to run 'Start-Process Eaglesoft.exe -Verb RunAs' with elevated credentials.

-----StartESEncryptedPassword.ps1-----

#set location

$LocalPath = ($MyInvocation.MyCommand.Path).replace("StartESEncryptedPassword.ps1", "")

#Get credentials to run ES as pattersonServiceAccount

$password = Get-Content $LocalPath\password.txt | ConvertTo-SecureString -Key (Get-Content $LocalPath\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("ad\PattersonServiceAcco",$password)

$credential

Start-process powershell.exe -Credential $credential -windowstyle hidden -ArgumentList "Start-Process Eaglesoft.exe -Verb runAs"


     