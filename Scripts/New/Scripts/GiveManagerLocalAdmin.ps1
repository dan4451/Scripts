############################################################################### 
# Script intended to run as a computer startup script to add a user that      #
# is referenced in the "manager" attribute to the local administrator group.  #
#                                                                             #
# The "manager" attribute for the computer should be populated with the DN of #
# the user, just like the managedBy attribute.                                #
###############################################################################


# Change to $VerbosePreference = "Continue" if more output is required
$VerbosePreference = "SilentlyContinue"

function Get-ADSIUser ($UserDistinguishedName)
{
        $root = [ADSI]'';
        $searcher = New-Object System.DirectoryServices.DirectorySearcher($root);
        $searcher.filter = "(&(objectClass=user)(distinguishedName= $UserDistinguishedName))";
        $user = $searcher.FindOne().GetDirectoryEntry()
        return $user
} 

function Get-ADSIComputer ($ComputerAccountName)
{
        $root = [ADSI]'';
        $searcher = New-Object System.DirectoryServices.DirectorySearcher($root);
        $searcher.filter = "(&(objectCategory=computer)(sAMAccountName=$ComputerAccountName))";
        $computer = $searcher.FindOne().GetDirectoryEntry()
        return $computer
} 


try {
    New-EventLog -LogName Application -Source "Specops Local Admin Mgmt" -ErrorAction SilentlyContinue

    $computerName = $Env:COMPUTERNAME + "$"
    
    $currentComputer = Get-ADSIComputer($computerName)

    if ($currentComputer.manager -ne $null) {
        Write-Verbose "Manager attribute in AD is $($currentComputer.manager)"
        
        $managerUser = Get-ADSIUser $currentComputer.manager
        $binarySID = $managerUser.ObjectSid.Value
        $objSID = New-Object System.Security.Principal.SecurityIdentifier($binarySID,0)
        $objUser = ($objSID.Translate( [System.Security.Principal.NTAccount])).Value  
        Write-Verbose "User name referenced in the manager attribute in AD is $objUser"
 
        # The local Administrator group SID is S-1-5-32-544
        $localUserAdded =  Get-LocalGroupMember -SID S-1-5-32-544 -Member $objUser -ErrorAction SilentlyContinue

        if ($localUserAdded -eq $null) {

            Write-Verbose "User $objUser will be added to local Administrators group ..."
            Add-LocalGroupMember -SID S-1-5-32-544 -Member $objUser
            Write-Output "Added user $objUser to local Administrators group ..."            
            Write-EventLog -LogName Application -EntryType Information -EventId 100 -Source "Specops Local Admin Mgmt" -Message "Added user $objUser to local Administrators group."

        } else
        {

            Write-Verbose "User already a member of the local Administrators Group, no action taken ..."
            Write-EventLog -LogName Application -EntryType Information -EventId 101 -Source "Specops Local Admin Mgmt" -Message "User $objUser already a member of the local Administrators Group, no action taken."
        }

     } else
     {
        Write-Verbose "No administrator assigned to this computer, no action taken ..."
        Write-EventLog -LogName Application -EntryType Information -EventId 102 -Source "Specops Local Admin Mgmt" -Message "No administrator assigned to this computer, no action taken."
     }
 }
 catch [System.SystemException]
 {

    Write-Output "Failed to add local admin with the following exception: $_"

    New-EventLog -LogName Application -Source "Specops Local Admin Mgmt" -ErrorAction SilentlyContinue
    Write-EventLog -LogName Application -EntryType Error -EventId 200 -Source "Specops Local Admin Mgmt" -Message "Failed to add local admin with the following exception: $_"
 }