#Function to Get Permissions Applied on a particular Object such as: Web, List, Library, Folder or List Item
Function Get-PnPPermissions([Microsoft.SharePoint.Client.SecurableObject]$Object)
{
    Try {
        #Get permissions assigned to the Folder
        Get-PnPProperty -ClientObject $Object -Property HasUniqueRoleAssignments, RoleAssignments
 
        #Check if Object has unique permissions
        $HasUniquePermissions = $Object.HasUniqueRoleAssignments
    
        #Loop through each permission assigned and extract details
        $PermissionCollection = @()
        Foreach($RoleAssignment in $Object.RoleAssignments)
        {
            #Get the Permission Levels assigned and Member
            Get-PnPProperty -ClientObject $RoleAssignment -Property RoleDefinitionBindings, Member
    
            #Get the Principal Type: User, SP Group, AD Group
            $PermissionType = $RoleAssignment.Member.PrincipalType
            $PermissionLevels = $RoleAssignment.RoleDefinitionBindings | Select -ExpandProperty Name
 
            #Remove Limited Access
            $PermissionLevels = ($PermissionLevels | Where { $_ -ne "Limited Access"}) -join ","
            If($PermissionLevels.Length -eq 0) {Continue}
 
            #Get SharePoint group members
            If($PermissionType -eq "SharePointGroup")
            {
                #Get Group Members
                $GroupMembers = Get-PnPGroupMember -Identity $RoleAssignment.Member.LoginName
                 
                #Leave Empty Groups
                If($GroupMembers.count -eq 0){Continue}
 
                ForEach($User in $GroupMembers)
                {
                    #Add the Data to Object
                    $Permissions = New-Object PSObject
                    $Permissions | Add-Member NoteProperty User($User.Title)
                    $Permissions | Add-Member NoteProperty Type($PermissionType)
                    $Permissions | Add-Member NoteProperty Permissions($PermissionLevels)
                    $Permissions | Add-Member NoteProperty GrantedThrough("SharePoint Group: $($RoleAssignment.Member.LoginName)")
                    $PermissionCollection += $Permissions
                }
            }
            Else
            {
                #Add the Data to Object
                $Permissions = New-Object PSObject
                $Permissions | Add-Member NoteProperty User($RoleAssignment.Member.Title)
                $Permissions | Add-Member NoteProperty Type($PermissionType)
                $Permissions | Add-Member NoteProperty Permissions($PermissionLevels)
                $Permissions | Add-Member NoteProperty GrantedThrough("Direct Permissions")
                $PermissionCollection += $Permissions
            }
        }
        #Export Permissions to CSV File
        $PermissionCollection | Export-CSV $ReportFile -NoTypeInformation
        Write-host -f Green "`n*** Folder Permission Report Generated Successfully!***"
    }
    Catch {
    write-host -f Red "Error Generating Folder Permission Report!" $_.Exception.Message
    }
}
   
#region ***Parameters***
$SiteURL="https://maravai.sharepoint.com/sites/TriLinkDistributorPortal"
$ReportFile="C:\FolderPermissionRpt.csv"
$FolderRelativeURL = "/Shared Documents/Trilink Distributors"
#endregion
 
#Connect to the Site collection
Connect-PnPOnline -URL $SiteURL -useweblogin
 
#Get the Folder from URL
$Folder = Get-PnPFolder -Url $FolderRelativeURL
 
#Call the function to generate permission report
Get-PnPPermissions $Folder.ListItemAllFields


#Read more: https://www.sharepointdiary.com/2018/03/sharepoint-online-powershell-to-get-folder-permissions.html#ixzz7D4IC3MGf