#--------------------------------------------------------------------------------------------------------------------
#  Script:   SCSM Security Roles
#  Author:   www.xapity.com
#  Date:     2017-10-22
#  Version:  1.0
#  Comments: Various options for Security User Roles
#
#--------------------------------------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------------------------------------
# Set Script Variables
#--------------------------------------------------------------------------------------------------------------------

$ADGroupCache = @{}
$UserGroups = @{}
$Script:UserGroupOutObject =@()

$script:AllSecurityRoles = @()
$script:AllSMLetsRoles = @()
$script:SMRoles = @()
$script:SecurityRole = @()
$Script:ReportData = @()
$Script:ReportSMRoles = @()
$Script:AllGroupsCheck = 0

$Script:AllRolesCheck = $null
$Script:SpecificRoleCheck = $null
$script:ReportFolderPath = "C:"
$script:ReverseDate = Get-date -format yyyy-MM-dd

$script:CurrentRole = "No Current Role set Yet"

#--------------------------------------------------------------------------------------------------------------------
# Test Powershell and AD Modules
#--------------------------------------------------------------------------------------------------------------------

 
# Service Manager Administrator Module - The reg key stores the SCSM install directory and from there we can load SCSM PowerShell.
$InstallationConfigKey = 'HKLM:\SOFTWARE\Microsoft\System Center\2010\Service Manager\Setup'
$Script:SCSMPowershellInstall  = (Get-ItemProperty -Path $InstallationConfigKey -Name InstallDirectory).InstallDirectory + "Powershell\System.Center.Service.Manager.psd1"

Try { Import-Module -Name $Script:SCSMPowershellInstall -Force -ErrorAction Stop }
Catch { 
        $PowershellError =  "      Error: Service Manager Powershell Module not loaded. "
        $PowershellCheck = "Fail"
        }

# Import of Active Directory Powershell Module. Required to find User recurive group membership.
Try {Import-Module  ActiveDirectory -ErrorAction Stop} 
Catch 
    {  
        $ADError = "      Error: Active Directory Powershell Module not loaded. "
        $PowershellCheck= "Fail"
    }  

If ($PowershellCheck -eq "Fail") 
    {
        Write-Host -ForegroundColor Red "==================================================================================================================="
        Write-Host -ForegroundColor Red "ERRORS Found"
        Write-Host -ForegroundColor Red "==================================================================================================================="
        Write-host
        Write-host -ForegroundColor Red "One of the following was not found: SCSM Powershell, SMLets or AD powershell require."
        Write-host -ForegroundColor Red "This script will not run as expected. Please install required component on this computer or run from different computer."
        Write-host
        Write-host -ForegroundColor Red "$PowershellError"
        #Write-host -ForegroundColor Red "$SMLEtsError"
        Write-host -ForegroundColor Red "$ADError"
        Write-host 
        #Exit
    } # End IF Fail


#--------------------------------------------------------------------------------------------------------------------
# Function: Get All Roles
#--------------------------------------------------------------------------------------------------------------------
Function Get-AllRoles
{
    
    If ($Script:AllRolesCheck -eq $null)
      {
        Write-host
        Write-host
        Write-host "Getting all security roles. This can take 2-4 mins if there are a lot of security roles."
        Write-host "     Most of the scripts use this information to check the `"All`" settings eg Alltasks, Allgroups, Allqueues..."
        Write-host "     Please be patint while it retrives the data"
        Write-host
        $script:AllSecurityRoles = Get-SCSMUserRole 
        $Script:AllRolesCheck = "All Roles already populated"
      } # End of If

}# End of Function Get-AllRoles
  

#--------------------------------------------------------------------------------------------------------------------
# Function: Get Specific Role
#--------------------------------------------------------------------------------------------------------------------
Function Get-SpecificRole
{ Param ([string]$InputRole)
    $errorCheck = "Fail"

    If ($script:CurrentRole -ne "No Current Role set Yet") {$errorCheck = "Pass" }
    
    # Check if user selected current role as the input -> Enter key used
    If (($InputRole -eq [string]::empty) -AND ($errorCheck -eq "Pass"))
      {
      #Can Assume SpecificRole has already run before and is populated with current value
      }

    Else
     { #run the SpecificRole function
        # Check that the Role Group Exists
        $script:SecurityRole = Get-SCSMUserRole $InputRole 

        # The rolecheck will return null if role does not exist
        If ($script:SecurityRole -ne $Null) 
            {
                $script:CurrentRole = $InputRole
         
            } # End of Role Check -ne Null

        Else {  Write-host; Write-host -foregroundcolor red  "Could not find Role"
                Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor Yellow "15. List All Roles" 
                $DataChange = "Y" }

    } # End of Else SecificRole Function
    Write-Host " ErrorCheck End: $errorCheck"  
    Write-Host " script:CurrentRole End: $script:CurrentRole"
    Write-Host " InputRole End: $InputRole"  
}# End of Function Get-SpecificRole


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 1 - Specific Role Users and Groups (Direct Level Only)
#--------------------------------------------------------------------------------------------------------------------
Function Get-DirectUsersGroups
{
    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Direct Users and Groups for $($script:SecurityRole.displayname)"
    Write-Host "=========================================================================="
    ForEach ($User in $script:SecurityRole.User)
    {
        Write-Host "   $($User)"
    }  # End of ForEach User

} # End of Function DirectUsersGroups


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 2 - Specific Role Console Tasks
#--------------------------------------------------------------------------------------------------------------------
Function Get-ConsoleTasks
{   $TaskData = @()

    If ($SecurityRole.AllTasks -eq $True)
            {$TaskData += [pscustomobject]@{
                Match = "All Tasks";
                Task = $SecurityRole.DisplayName;
                ManagementPackName = "" }
            }  # End of IF All Tasks True


        Else 
        {
            ForEach ($Task in $SecurityRole.Task)
                {
                    $TaskData += [pscustomobject]@{
                                Match = "Direct Enabled";
                                Task = $Task.DisplayName;
                                ManagementPackName = $Task.ManagementPackName }
                } # End ForEach Task
            } # End Else


        #Write to screen
        Write-Host
        Write-Host "=========================================================================="
        Write-Host "Console Tasks for $($script:SecurityRole.displayname)"
        Write-Host "=========================================================================="
        $TaskData | Sort Task | FT -AutoSize 


} # End of Function ConsoleTasks


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 3 - Specific Role Form Templates
#--------------------------------------------------------------------------------------------------------------------
Function Get-FormTemplates
{  $TemplateData = @()   

    If ($SecurityRole.AllTasks -eq $True)
        {$TemplateData += [pscustomobject]@{
                Match = "All Templates";
                Template = $SecurityRole.DisplayName;
                ManagementPackName = ""}   # End of custom object
        }  # End of If All Templates True


    Else 
    {
            ForEach ($Template in $script:SecurityRole.FormTemplate)
        {
            $TemplateData += [pscustomobject]@{
                            Match = "Direct Enabled";
                            Template = $Template.DisplayName;
                            ManagementPackName = $Template.ManagementPack }
        } # End ForEach Template
    } # End If Else

    #Write to screen
    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Form Templates for $($script:SecurityRole.displayname)"
    Write-Host "=========================================================================="
    $TemplateData | Sort Template | FT -AutoSize 


} # End of Function FormTemplates


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 4 - Specific Role Console Views
#--------------------------------------------------------------------------------------------------------------------
Function Get-ConsoleViews
{   $ViewData = @()

    If ($SecurityRole.AllViews -eq $True)
        {$ViewData += [pscustomobject]@{
                Match = "All Views";
                View = $SecurityRole.DisplayName;
                ManagementPackName = "" }  
        }  # End of IF All Views True

        Else
        {    
        ForEach ($View in $script:SecurityRole.View)
            {
            If ( $View.Displayname -ne $Null) 
                {$ViewData += [pscustomobject]@{
                            Match = "Direct Enabled";
                            View = $View.DisplayName;
                            ManagementPackName = $View.ManagementPackName }
                } # End Viewdata not Null
            } # End ForEach Task
        } # End Else 

    #Write to screen
    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Console Views for $($script:SecurityRole.displayname)"
    Write-Host "=========================================================================="
    $ViewData | Sort View | FT -AutoSize 


} # End of Function ConsoleViews


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 5 - Specific Role Queues
#--------------------------------------------------------------------------------------------------------------------
Function Get-Queues
{   $ObjectData = @()

    If ($SecurityRole.AllQueues -eq $True)
        {
            $ObjectData += [pscustomobject]@{
                    Match = "All Queues";
                    Object = $SecurityRole.DisplayName;
                    ManagementPackName = ""}   # End of custom object     
        }  # End of If
    Else {
            ForEach ($Object in $SecurityRole.Queue)
                {  $ObjectData += [pscustomobject]@{
                        Match = "Direct Enabled";
                        Object = $Object.DisplayName;
                        ManagementPackName = ""}   # End of custom object 
                } # End For Each
        } # End Else
        
    #Write to screen
    Write-Host
    Write-host
    Write-Host "=========================================================================="
    Write-Host "Queues for $($script:SecurityRole.displayname)"
    Write-Host "=========================================================================="
    $ObjectData | Sort Object | FT -AutoSize 

} # End of Function Queues


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 6 - Specific Role CI Groups
#--------------------------------------------------------------------------------------------------------------------
Function Get-CIGroups
{   $ObjectData = @()
    
    If ($SecurityRole.AllGroups -eq $True)
        {
            $ObjectData += [pscustomobject]@{
                    Match = "All CI Groups";
                    Object = $SecurityRole.DisplayName;
                    ManagementPackName = ""}   # End of custom object    
        }  # End of If
    Else {
            ForEach ($Object in $SecurityRole.Group)
                {  $ObjectData += [pscustomobject]@{
                        Match = "Direct Enabled";
                        Object = $Object.DisplayName;
                        ManagementPackName = ""}   # End of custom object 
                } # End For Each
        } # End Else       
        
    #Write to screen
    Write-Host
    Write-host
    Write-Host "=========================================================================="
    Write-Host "CI Groups for $($script:SecurityRole.displayname)"
    Write-Host "=========================================================================="
    $ObjectData | Sort Object | FT -AutoSize 
            
 } # End of Function CI Groups


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 7 - Specific Role Catalog Groups
#--------------------------------------------------------------------------------------------------------------------
Function Get-CatalogGroups
{   $ObjectData = @()

    If ($SecurityRole.AllCatalogGroups -eq $True)
        {
            $ObjectData += [pscustomobject]@{
                    Match = "All Catalog Groups";
                    Object = $Role.DisplayName;
                    ManagementPackName = ""}   # End of custom object
        }  # End of If
    Else {
            ForEach ($Object in $SecurityRole.CatalogGroup)
                {  $ObjectData += [pscustomobject]@{
                        Match = "Direct Enabled";
                        Object = $Object.DisplayName;
                        ManagementPackName = ""}   # End of custom object 
                } # End ForEach
            } # End Else
        
    #Write to screen
    Write-Host
    Write-host
    Write-Host "=========================================================================="
    Write-Host "Catalog Groups for $($script:SecurityRole.displayname) "
    Write-Host "=========================================================================="
    $ObjectData | Sort Object | FT -AutoSize 

} # End of Function Catalog Groups


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 8a - Get Recursive Groups for a User
#--------------------------------------------------------------------------------------------------------------------
Function Get-RecursiveGroups
{
    $Script:UserGroupOutObject =@()

    #
    # The Source Powershell Code came from:
    #        https://www.sysadmins.lv/blog-en/efficient-way-to-get-ad-user-membership-recursively-with-powershell.aspx
    # introduce two lookup hashtables. First will contain cached AD groups,
    # second will contain user groups. We will reuse it for each user.
    # format: Key = group distinguished name, Value = ADGroup object

    # define recursive function to recursively process groups.
    function __findPath ([string]$currentGroup) {
        Write-Verbose "Processing group: $currentGroup"
        # we must do processing only if the group is not already processed.
        # otherwise we will get an infinity loop
        if (!$UserGroups.ContainsKey($currentGroup)) {
            # retrieve group object, either, from cache (if is already cached)
            # or from Active Directory
            $groupObject = if ($ADGroupCache.ContainsKey($currentGroup)) {
                Write-Verbose "Found group in cache: $currentGroup"
                $ADGroupCache[$currentGroup].Psobject.Copy()
            } else {
                Write-Verbose "Group: $currentGroup is not presented in cache. Retrieve and cache."
                $group = Get-ADGroup -Identity $currentGroup -Property objectclass,sid,whenchanged,whencreated,samaccountname,displayname,cn,enabled,distinguishedname,memberof,groupscope,groupcategory
                # immediately add group to local cache:
                $ADGroupCache.Add($group.DistinguishedName, $group)
                $group
            }
            # add current group to user groups
            $UserGroups.Add($currentGroup, $groupObject)
            Write-Verbose "Member of: $currentGroup"
            foreach ($p in $groupObject.MemberOf) {
                __findPath $p
            }
        } else {Write-Verbose "Closed walk or duplicate on '$currentGroup'. Skipping."}
    } # End Function FindPath

    # Main Function Block    
    $Script:UserObject = Get-ADUser -Identity $Script:Username -Property objectclass,sid,samaccountname,displayname,distinguishedname,cn,memberof
    $Script:UserObject.MemberOf | ForEach-Object {__findPath $_ $Script:UserObject.SamAccountName}
           
    foreach($group in $UserGroups.GetEnumerator())
    {
        $Script:UserGroupOutObject += [pscustomobject]@{
            ObjectClass = $group.value.ObjectClass;
            User_SamAccountName = $Script:UserObject.SamAccountName;
            User_DisplayName = $Script:UserObject.DisplayName;
            GroupDN = $group.Value.DistinguishedName;
            Group_SamAccountName = $group.value.SamAccountName;
            GroupName = $group.Value.Name;
            GroupCN = $group.Value.cn;
            GroupDisplayName = $group.Value.DisplayName;
            GroupScope = $group.value.GroupScope;
            GroupCategory = $group.value.GroupCategory;
            WhenChanged = $group.value.WhenChanged;
            WhenCreated = $group.value.WhenCreated;
        }
    }

} # End Function Get Recursive Groups


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 8b - Roles that contain Users
#--------------------------------------------------------------------------------------------------------------------
Function Get-UserRoles 
{
    $Script:UserRolesOutObject = @()
    
     ForEach ($Role in $Script:AllSecurityRoles)
     { 
         ForEach ($User in $Role.User)
        {
            $UserSamAccountName = $User.Substring($User.IndexOf("\")+1)

            If ($UserSamAccountName -eq $Script:Username)
                { $Script:UserRolesOutObject += [pscustomobject]@{
                        Role = $Role.DisplayName;
                        Group = "Direct Assigned"
                        }
                } # End If
            
            ElseIf ($UserSamAccountName -eq "Authenticated Users")
                {$Script:UserRolesOutObject += [pscustomobject]@{
                        Role = $Role.DisplayName;
                        Group = "Authenticated Users"
                        }
                 } # End ElseIF
             
            Else
            {   
                # Check the Recursive groups to see if they match the User(group) name
                ForEach ($Group in $Script:UserGroupOutObject)
                  {
                    If ($UserSamAccountName -eq $Group.Group_SamAccountName)
                          {$Script:UserRolesOutObject += [pscustomobject]@{
                               Role = $Role.DisplayName;
                               Group = $Group.Group_SamAccountName
                               }
                          } # End Else
                    
                   # Write-Host "    Role: $($Role.DisplayName)    `tGroup: $Group.Group_SamAccountName"}

                  } # End ForEach Group

            } # End of Else

        } # End of ForEach User

      } # End of ForEach Role

      #Write to screen
      Write-Host
      Write-Host "=========================================================================="
      Write-Host "Roles for User: `"$($Script:UserObject.DisplayName)`""
      Write-Host "=========================================================================="

      $Script:UserRolesOutObject | Sort Role | FT -AutoSize


      Write-Host
      Write-Host
      Write-Host
      Write-Host -ForegroundColor Yellow " Do you want to view Users recursive group membership? Y/N (default N): "-nonewline ; $InputUserRecursiveGroups = Read-Host 
      
      
      If ($InputUserRecursiveGroups  -eq "Y") 
         {
                Write-Host
                Write-Host
                Write-Host "=========================================================================="
                Write-Host "Groups (recursive) for User: $($Script:Username)"
                Write-Host "=========================================================================="
    
                $Script:UserGroupOutObject | Sort Group_SamAccountName | Select Objectclass, User_Displayname, Group_SamAccountName | FT -Auto 

                Write-Host
                Write-Host

        } # End IF 


} # End of Function UserRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 9 - Get Roles with All Settings
#--------------------------------------------------------------------------------------------------------------------
Function Get-AllSettingRoles 
{
    $AllSettingsData = @()

    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Roles with All Settings Enabled"
    Write-Host "=========================================================================="

    ForEach ($Role in $Script:AllSecurityRoles )
     {  
        $Match = 0
        If ($Role.AllClases -eq $True) 
               { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Classes"}
                 $Match = 1
               }
                               
        If ($Role.AllGroups -eq $True) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Groups"}
                  $Match = 1
                }
        If ($Role.AllCatalogGroups -eq $True) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Catalog Groups"}
                  $Match = 1
                }
        If ($Role.AllQueues -eq $True) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Queues"}
                  $Match = 1
                }

        If ($Role.AllFormTemplates -eq $True) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Templates"}
                  $Match = 1
                }
        If ($Role.AllViews -eq $True) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Views"}
                  $Match = 1
                }
        If ($Role.AllTasks -eq $True) 
                 { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "All Tasks"}
                  $Match = 1
                }
        If ($Match -eq 0) 
                { $AllSettingsData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Setting = "Custom Only Settings"}
                }
    } # End ForEach Role  

    $AllSettingsData  | Sort RoleName | FT -AutoSize
   
    
} # End of Function AllSettingRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 10 - Roles that contain a Task
#--------------------------------------------------------------------------------------------------------------------
Function Get-TaskRoles ([string]$InputTask)
{
    $TaskData = @()
    $TaskCheck = "Pass"

    Try {$TempTask = Get-SCSMTask $InputTask  -ErrorAction Stop}
    Catch {$TaskCheck = "Fail"}

    If ($TaskCheck -eq "Pass") 
    {    
        ForEach ($Role in $Script:AllSecurityRoles)
        {
            If ($Role.AllTasks -eq $True)
            {$TaskData += [pscustomobject]@{
                    Match = "All Tasks";
                    Role = $Role.DisplayName;
                    ManagementPackName = "" }   # End of custom object
        
            }  # End of If

            Else 
            {
              ForEach ($Task in $Role.Task)
                {
                  If($Task.Displayname -eq $InputTask)
                    {$TaskData += [pscustomobject]@{
                             Match = "Direct Enabled";
                             Role = $Role.DisplayName;
                             ManagementPackName = $Task.ManagementPackName }
                    } # End of IF
                } # End ForEach Role

            } # End Else
        } # End ForEach Role   
    
        #Write to screen
        Write-Host
        Write-Host "=========================================================================="
        Write-Host "Roles for Task: $InputTask"
        Write-Host "=========================================================================="
        $TaskData | Sort Match -Descending | FT -AutoSize 
    
    } # End IF Taskcheck eq Pass

    Else
    {
        Write-host
        Write-host -foregroundcolor red  "Could not find Task"
        Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor Green "20. List All Tasks"
    } # End Else

} # End of Function TaskRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 11 - Roles that contain Catalog Groups
#--------------------------------------------------------------------------------------------------------------------
Function Get-CatalogGroupRoles ([string]$InputGroup)
{
    $CatalogData = @()
    $CatalogDataCheck = $null

    ForEach ($Role in $Script:AllSecurityRoles)
     {
        If ($Role.AllCatalogGroups -eq $True)
           {
             $CatalogData += [pscustomobject]@{
                Match = "All Catalog Groups";
                Role = $Role.DisplayName;
                ManagementPackName = ""
                }  # End of custom object
  
            }  # End of If
         Else 
           {
             ForEach ($CatalogGroup in $Role.CatalogGroup)
                {
                    If($CatalogGroup.Displayname -eq $InputGroup)
                      {$CatalogData += [pscustomobject]@{
                        Match = "Direct Enabled";
                        Role = $Role.DisplayName;
                        ManagementPackName = $CatalogGroup.ManagementPackName} 
                        $CatalogDataCheck = "Catalog Group Found"
                    } # End IF    
         
                } # End ForEach CI Group
             }  # End of Else
            
    } # End ForEach Role 
    
    
    #Write to screen
    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Roles for Catalog Group: $InputGroup "
    Write-Host "=========================================================================="
    If ($CatalogDataCheck -eq $null) {Write-Host "Group may not exist. It is in no direct roles."
                                      Write-Host
                                      Write-Host "These roles have All set:"}
    $CatalogData | Sort Match -Descending | FT -AutoSize
    
} # End of Function CatalogGroupRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 12 - Roles that contain a Template
#--------------------------------------------------------------------------------------------------------------------
Function Get-TemplateRoles ([string]$InputTemplate)
{    
     $TemplateData = @()

     $TemplateCheck = Get-SCSMObjectTemplate -DisplayName  $InputTemplate
     If ($TemplateCheck -ne $Null)
     {
            ForEach ($Role in $Script:AllSecurityRoles)
            {
                If ($Role.AllFormTemplates -eq $True)
                {$TemplateData += [pscustomobject]@{
                        Match = "All Templates";
                        Role = $Role.DisplayName;
                        ManagementPackName = "";
                        } # End of custom object
                    }  # End of If

                Else 
                {
                    ForEach ($Template in $Role.FormTemplate)
                    {
                        If($Template.Displayname -eq $InputTemplate)
                        {$TemplateData += [pscustomobject]@{
                                    Match = "Direct Enabled";
                                    Role = $Role.DisplayName;
                                    ManagementPackName = $Template.ManagementPackName}
                            } # End of If
                    } # End ForEach Template

                } # End Else
            } # End ForEach Role 
     
            #Write to screen
            Write-Host
            Write-Host "=========================================================================="
            Write-Host "Roles for Template: $InputTemplate"
            Write-Host "=========================================================================="
            $TemplateData | Sort Match -Descending | FT -AutoSize  

    
        } # End TemplateCheck 

   Else
   {
        Write-host
        Write-host -foregroundcolor red  "Could not find Template"
        Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor Green "16. List All Templates"
   }

    
} # End of Function TemplateRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 13 -  Roles that contain a View
#--------------------------------------------------------------------------------------------------------------------
Function Get-ViewRoles ([string]$InputView)
{  
    $ViewData = @()
    $ViewCheck = "Pass"

    Try {$TempView = Get-SCSMView $InputView  -ErrorAction Stop}
    Catch {$ViewCheck = "Fail"}

    If ($ViewCheck -eq "Pass") 
    {

        Write-Host
        Write-Host "=========================================================================="
        Write-Host "Roles for View: $InputView"
        Write-Host "=========================================================================="

        ForEach ($Role in $AllSecurityRoles)
        {
            If ($Role.AllViews -eq $True)
            {$ViewData += [pscustomobject]@{
                    Match = "All Views";
                    Role = $Role.DisplayName;
                    ManagementPackName = ""}   # End of custom object
        
            }  # End of If

            Else 
            {
              ForEach ($View in $Role.View)
                {
                If($View.Displayname -eq $InputView)
                    {$ViewData += [pscustomobject]@{
                             Match = "Direct Enabled";
                             Role = $Role.DisplayName;
                             ManagementPackName = $View.ManagementPackName }
                    } # End of IF
                } # End ForEach View

            } # End Else
        } # End ForEach Role

         #Write to screen
        $ViewData | Sort Match -Descending | FT -AutoSize

        } # End IF Viewcheck eq Pass

    Else
    {
        Write-host
        Write-host -foregroundcolor red  "Could not find View"
        Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor Green "17. List All Views"
    } # End Else
        
} # End of Function ViewRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 14 - Roles that contain CI Groups
#--------------------------------------------------------------------------------------------------------------------
Function Get-CIGroupRoles ([string]$InputCIGroup)
{
    $CIGroupData = @()
    $CICheck = Get-SCSMGroup -DisplayName $InputCIGroup

    If ($CICheck -ne $Null)
    {

        ForEach ($Role in $Script:AllSecurityRoles)
         {
            If ($Role.AllGroups -eq $True)
               {
                 $CIGroupData += [pscustomobject]@{
                    Match = "All CI Groups";
                    Role = $Role.DisplayName;
                    ManagementPackName = ""}  # End of custom object
  
                }  # End of If
             Else 
               {
                 ForEach ($CIGroup in $Role.Group)
                    {
                        If($CIGroup.Displayname -eq $InputCIGroup)
                          {$CIGroupData += [pscustomobject]@{
                            Match = "Direct Enabled";
                            Role = $Role.DisplayName;
                            ManagementPackName = $CIGroup.ManagementPackName}
                        } # End IF    
         
                    } # End ForEach CI Group
                 }  # End of Else
            
        } # End ForEach Role 
    
        #Write to screen
        Write-Host
        Write-Host "=========================================================================="
        Write-Host "Roles for CI Group: $InputCIGroup "
        Write-Host "=========================================================================="
        $CIGroupData | Sort Match -Descending  | FT -AutoSize

       } # End IF CICheck

    Else
    {
        Write-host
        Write-host -foregroundcolor red  "Invalid CI Group Name"
        Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor  Green "18. List All CI Groups"
    }

    
} # End of Function CIGroupRoles


#--------------------------------------------------------------------------------------------------------------------
# Function: Input 15 - Roles that contain Queues
#--------------------------------------------------------------------------------------------------------------------
Function Get-QueueRoles ([string]$InputQueue)
{    
    $QueueData = @()
    $QueueCheck = "Pass"

    Try {Get-SCSMQueue -DisplayName $InputQueue  -ErrorAction Stop}
    Catch {$QueueCheck = "Fail"}

    If ($QueueCheck -eq "Pass")
    {
        ForEach ($Role in $Script:AllSecurityRoles)
         {
            If ($Role.AllQueues -eq $True)
               {
                 $QueueData += [pscustomobject]@{
                    Match = "All Queues";
                    Role = $Role.DisplayName;
                    ManagementPackName = ""} # End of custom object
  
                }  # End of If
             Else 
               {
                 ForEach ($Queue in $Role.Queue)
                    {
                        If($Queue.Displayname -eq $InputQueue)
                          {$QueueData += [pscustomobject]@{
                            Match = "Direct Enabled";
                            Role = $Role.DisplayName;
                            ManagementPackName = $Queue.ManagementPackName} 
                        } # End IF    
         
                    } # End ForEach CI Group
                 }  # End of Else

        } # End ForEach Role 

        #Write to screen
        Write-Host
        Write-Host "=========================================================================="
        Write-Host "Roles for Queue: $InputQueue "
        Write-Host "     - From Service Manager Powershell"
        Write-Host "=========================================================================="
        $QueueData | Sort Match -Descending | FT -AutoSize

    } # End IF QueueCheck eq Pass

    Else
    {
        Write-host
        Write-host -foregroundcolor red  "Invalid Queue Name"; 
        Write-host -foregroundcolor red  "    Confirm by checking:  " -nonewline; Write-host -foregroundcolor Green "19. List All Queues"
    } # End Else
       
} # End of Function QueueRoles



#--------------------------------------------------------------------------------------------------------------------
# Function: Input 22 & 23 - Get Report object
#--------------------------------------------------------------------------------------------------------------------
Function Get-ReportObject ([string]$InputReportType)
{
    $Script:ReportData = @()
    
    If ($InputReportType -eq "Full_SCSMReport")
           {$Script:ReportSMRoles = $script:AllSecurityRoles}

    Else   {$Script:ReportSMRoles = $script:SecurityRole}
    
    # Set the default  Report File Locations
    $script:ReportFilename = $InputReportType +"_SCSMReport_" +$script:ReverseDate
    $script:ReportLocation = $script:ReportFolderPath + "\" + $script:ReportFilename + ".csv" 

    Write-Host
    Write-Host "=========================================================================="
    Write-Host "Getting Report data for $InputReportType"
    Write-Host "=========================================================================="

    
    # Get the data from the Standard Service Manager Role Data
    ForEach ($Role in $Script:ReportSMRoles)
     {  
       Write-Host "  Processing: $($Role)"

        Write-Host "      Processing: Users"
        #--------------------------------------------------------------------------------------------------------------------
        ForEach ($User in $Role.User)
          {
            $UserSamAccountName = $User.Substring($User.IndexOf("\")+1)

            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "User";
                               User = $User;
                               SamAccountName = $UserSamAccountName;
                               DisplayName = $Null;
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

          } # End of ForEach User
       

        Write-Host "      Processing: Tasks"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.AllTasks -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Task";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All Tasks Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }


        } # End If ($Roles.AllTasks -eq $True)

        Else 
        {    
            ForEach ($Task in $Role.Task)
            {
              $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Task";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $Task.DisplayName ;
                               ManagementPackName = $Task.ManagementPack;
                               Description = $Task.Description 
                               }

            } # End ForEach Task
        } # End Else 

        
        Write-Host "      Processing: Templates"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.AllFormTemplates -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Template";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All Templates Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

        } # End If ($Roles.AllFormTemplates -eq $True)

        Else 
        {    
            ForEach ($Template in $Role.FormTemplate)
            {
              $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Template";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $Template.DisplayName ;
                               ManagementPackName = $Template.ManagementPack;
                               Description = $Template.Description 
                               }
                
            } # End ForEach Template
        } # End Else 



        Write-Host "      Processing: Views"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.AllViews -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "View";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All Views Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

        } # End If ($Roles.AllViews -eq $True)

        Else 
        {    
            ForEach ($View in $Role.View)
            {
                $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "View";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $View.DisplayName ;
                               ManagementPackName = $View.ManagementPack;
                               Description = $View.Description 
                               }

            } # End ForEach View
        } # End Else 


        Write-Host "      Processing: CI Groups"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.AllGroups -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "CI Group";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All CI Groups Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

        } # End If ($Roles.AllGroups -eq $True)

        Else 
        {    
              ForEach ($Object in $Role.Group)
            {
                $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "CI Group";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $Object.DisplayName ;
                               ManagementPackName = $Object.ManagementPackName;
                               Description = $Object.Description 
                               }

            } # End ForEach Object
        } # End Else 

        Write-Host "      Processing: Catalog Groups"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.AllCatalogGroups  -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Catalog Group";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All Catalog Groups Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

        } # End If ($Roles.AllCatalogGroups -eq $True)

        Else 
        {    
              ForEach ($CatalogObject in $Role.CatalogGroup)
            {
                $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Catalog Group";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $CatalogObject.DisplayName ;
                               ManagementPackName = $CatalogObject.ManagementPackName;
                               Description = $CatalogObject.Description 
                               }

            } # End ForEach CatalogObject
        } # End Else 


        Write-Host "      Processing: Queues"
        #--------------------------------------------------------------------------------------------------------------------
        If ($Role.Queues -eq $True)
        {
            $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Queue";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = "All Queues Enabled";
                               ManagementPackName = $Null;
                               Description = $Null 
                               }

        } # End If ($Roles.Queues -eq $True)

        Else 
        {    
              ForEach ($QueueObject in $Role.Group)
            {
                $Script:ReportData += [pscustomobject]@{
                               RoleName = $Role.DisplayName;
                               Type = "Queue";
                               User = $null;
                               SamAccountName = $null;
                               DisplayName = $QueueObject.DisplayName ;
                               ManagementPackName = $QueueObject.ManagementPackName;
                               Description = $QueueObject.Description 
                               }

            } # End ForEach QueueObject
        } # End Else   
   } # End For Each Role



  #--------------------------------------------------------------------------------------------------------------------
  #  Menu for Report Output
  #--------------------------------------------------------------------------------------------------------------------
  
   Do  #second Do statement that runs the main menu
    {  

        #---------------------------------------------------------------------------------------------------------------------
        # Report Menu
        # 
        #---------------------------------------------------------------------------------------------------------------------       
        
        Write-Host 
        Write-Host 
        Write-Host -ForegroundColor Green "==================================================================================================================="
        Write-Host -ForegroundColor Green ""
        Write-Host -ForegroundColor Green "Report Options:"
        Write-Host -ForegroundColor Green ""
        Write-Host -ForegroundColor Green "==================================================================================================================="
        Write-Host -ForegroundColor yellow ""
        Write-Host -ForegroundColor yellow "    1. View Report on Screen "
        Write-Host -ForegroundColor yellow "    2. Save Report to Disk as CSV file to: $script:ReportLocation     " 
        Write-Host -ForegroundColor yellow " "
        Write-Host -ForegroundColor yellow " "
        Write-Host -ForegroundColor Green "Change disk and file name:  $script:ReportLocation     "
        Write-Host -ForegroundColor Green "-------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "    3. Change the Filename.   "
        Write-Host -ForegroundColor yellow "            Current value: $script:ReportFilename  "
        Write-Host -ForegroundColor yellow "    4. Change the folder path. "
        Write-Host -ForegroundColor yellow "            Current Value: $script:ReportFolderPath  "
        Write-Host -ForegroundColor yellow 
        Write-Host -ForegroundColor Green "Exit Report Menu:       "
        Write-Host -ForegroundColor Green "-------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "    x. Exit   "
        Write-Host -ForegroundColor yellow "  "
        Write-Host -ForegroundColor yellow
        write-host -foregroundColor green "To choose an option enter number " -NoNewline;  write-host -foregroundColor Yellow "(1-4) "  -nonewline;  write-host -foregroundColor green "or "  -nonewline ; write-host -foregroundColor Yellow "X " -nonewline; write-host -foregroundColor Green "to exit the Report Menu: " -nonewline; $ReportDataChange = Read-Host 
        write-host ""   
     Switch ($ReportDataChange) {
            1  {   Write-Host "=========================================================================="
                   Write-Host "Report Results for $Script:ReportFileName"
                   Write-Host "==========================================================================" 
                   $Script:ReportData | FT
                   $ReportDataChange = "N" } # End of Switch 1 block
            2  {Write-host -foregroundColor green "Saving Report to $script:ReportLocation"
                   $Script:ReportData | Export-Csv -path $script:ReportLocation -NoTypeInformation
                   $ReportDataChange = "y" } # End of Switch 2 block
            3  {Write-host -foregroundColor yellow "Enter new file name (with NO extension)"   -nonewline;$script:ReportFilename = Read-host
                   $script:ReportLocation = $script:ReportFolderPath + "\" + $script:ReportFilename + ".csv" 
                   $ReportDataChange = "N"  } # End of Switch 3 block
            4  {Write-host -foregroundColor yellow "Enter new folder path"   -nonewline; $script:ReportFolderPath = Read-host
                   $script:ReportLocation = $script:ReportFolderPath + "\" + $script:ReportFilename + ".csv"
                   $ReportDataChange = "N"  } # End of Switch 4 block
            x  {write-host -foregroundcolor Yellow "End of Report Menu."; Write-Host;  $ReportDataChange = "Y"}
            y  {$DataChange = "Y"}
            default {write-host -foregroundcolor red "Incorrect number entered. Please choose again."; write-host ""}
            } #End of Switch 
            
     }  Until ($ReportDataChange -eq "Y") 
    
} # End of Function Get-ReportObject



#--------------------------------------------------------------------------------------------------------------------
# Body of Script  
#--------------------------------------------------------------------------------------------------------------------

Do   #first Do statement allows repeating the search with the same starting inputs
{
    Do  #second Do statement that runs the main menu
    {  

        #---------------------------------------------------------------------------------------------------------------------
        # Main Menu
        # 
        #---------------------------------------------------------------------------------------------------------------------       
        
        Write-Host 
        Write-Host 
        Write-Host -ForegroundColor yellow "==================================================================================================================="
        Write-Host -ForegroundColor yellow ""
        Write-Host -ForegroundColor yellow "Security Role Options:"
        Write-Host -ForegroundColor yellow "==================================================================================================================="
        Write-Host -ForegroundColor Green ""
        Write-Host -ForegroundColor Green "Input Specific Role to:"
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "    1. Find Users and groups directly assigned to a role "
        Write-Host -ForegroundColor yellow "    2. Find Role assigned Tasks  " 
        Write-Host -ForegroundColor yellow "    3. Find Role assigned Templates " 
        Write-Host -ForegroundColor yellow "    4. Find Role assigned Views "
        Write-Host -ForegroundColor yellow "    5. Find Role assigned Queues  "
        Write-Host -ForegroundColor yellow "    6. Find Role assigned CI Groups"
        Write-Host -ForegroundColor yellow "    7. Find Role assigned Catalog Groups  "
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor Green "Input User to find Roles (Recursive Groups):"
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "    8. User ID for Recursive search of groups and Security Roles "
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor Green "Find where the All Tasks, All Views, All Templates, All Catalog Groups have been used"
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "    9. Where `"All`" settings have been used" 
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor Green "Input Object to find Roles:"
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "   10. Task name to find assinged Security Roles  "
        Write-Host -ForegroundColor yellow "   11. Catalog Group name to find assigned Security Roles "
        Write-Host -ForegroundColor yellow "   12. Template name to find assinged Security Roles "
        Write-Host -ForegroundColor yellow "   13. View name to find assigned Security Roles  "
        Write-Host -ForegroundColor yellow "   14. CI Group name to find assigned Security Roles "
        Write-Host -ForegroundColor yellow "   15. Queue name to find assigned Security Roles "
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor Green "List values For:                                             "
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "   16. List All Roles "
        Write-Host -ForegroundColor yellow "   17. List All Templates "
        Write-Host -ForegroundColor yellow "   18. List All Views "
        Write-Host -ForegroundColor yellow "   19. List All CI Groups "
        Write-Host -ForegroundColor yellow "   20. List All Queues "
        Write-Host -ForegroundColor yellow "   21. List All Tasks "
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor yellow
        Write-Host -ForegroundColor Green "Report Options - Exports to CSV All Users, Tasks, Templates, Views, Catalog Groups" 
        Write-Host -ForegroundColor Green "--------------------------------------------------------------------------------------------------------------------"
        Write-Host -ForegroundColor yellow "   22. CSV Report for Specific Security Role"
        Write-Host -ForegroundColor yellow "   23. CSV Report for ALL Security Roles"
        Write-Host -ForegroundColor yellow
        write-host -foregroundColor green "To choose an option enter number " -NoNewline;  write-host -foregroundColor Yellow "(1-23) "  -nonewline;  write-host -foregroundColor green "or "  -nonewline ; write-host -foregroundColor Yellow "X " -nonewline; write-host -foregroundColor Green "to exit the script: " -nonewline; $DataChange = Read-Host 
        write-host ""   
        Switch ($Datachange) {
             1 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-DirectUsersGroups
                                $DataChange = "Y" 
                                } # End of Switch 1 block
             2 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host 
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-ConsoleTasks
                                $DataChange = "Y" 
                                } # End of Switch 2 block
             3 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-FormTemplates
                                $DataChange = "Y" 
                                } # End of Switch 3 block
             4 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-ConsoleViews
                                $DataChange = "Y" 
                                } # End of Switch 4 block
             5 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-Queues
                                $DataChange = "Y" 
                                } # End of Switch 5 block
             6 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-CIGroups
                                $DataChange = "Y" 
                                } # End of Switch 6 block
             7 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-CatalogGroups
                                $DataChange = "Y"
                                } # End of Switch 7 block
             8 {Write-host -foregroundColor yellow "Input User ID (SamAccountName): " -nonewline;  $Script:Username = Read-host 
                                $UserCheck = "Pass"
                                Try {$Script:UserObject = Get-ADUser -Identity $Script:Username  -ErrorAction  Stop}
                                Catch {Write-host -foregroundcolor red  "Could not find User"; $UserCheck = "Fail"; $DataChange = "Y" }
                                If ($UserCheck -eq "Pass") 
                                    {  Get-AllRoles
                                       Get-RecursiveGroups
                                       Get-UserRoles
                                       $DataChange = "Y"
                                    }  # End If $UserCheck -eq "Pass"
                                } # End of Switch 8 block
            9 {Write-host -foregroundColor yellow "Running Report of All Settings use"   -nonewline
                                Get-AllRoles
                                Get-AllSettingRoles
                                $DataChange = "Y"  }# End of Switch 9 block
            10 {Write-host -foregroundColor yellow "Input Task name (Display Name): " -nonewline; $TaskInput = Read-host
                                Get-AllRoles
                                Get-TaskRoles -InputTask $TaskInput
                                $DataChange = "Y"
                                } # End of Switch 10 block   
            11 {Write-host -foregroundColor yellow "Input Catalog Group name (Display Name): " -nonewline; $CatalogInput = Read-host
                                Get-AllRoles
                                Get-CatalogGroupRoles -InputGroup $CatalogInput
                                $DataChange = "Y" 
                                } # End of Switch 11 block
            12 {Write-host -foregroundColor yellow "Input Template name (Display Name): " -nonewline; $TemplateInput = Read-host
                                Get-AllRoles
                                Get-TemplateRoles -InputTemplate $TemplateInput
                                $DataChange = "Y"
                                } # End of Switch 12 block
            13 {Write-host -foregroundColor yellow "Input View Name (Display Name): " -nonewline; $ViewInput = Read-host
                                Get-AllRoles
                                Get-ViewRoles -InputView $ViewInput
                                $DataChange = "Y" 
                                } # End of Switch 13 block   
            14 {Write-host -foregroundColor yellow "Input CI Group name (Display Name): " -nonewline; $CIInput = Read-host
                                Get-AllRoles
                                Get-CIGroupRoles -InputCIGroup $CIInput
                                $DataChange = "Y" 
                                } # End of Switch 14 block 
            15 {Write-host -foregroundColor yellow "Input Queue name (Display Name): " -nonewline; $QueueInput = Read-host
                                Get-AllRoles
                                Get-QueueRoles -InputGroup $QueueInput
                                $DataChange = "Y"
                                } # End of Switch 15 block                 
            16 {Write-host 
                                Get-AllRoles
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All Security Roles "
                                Write-Host "=========================================================================="
                                $Script:AllSecurityRoles | Select Displayname, Description |Sort Displayname | FT
                                $DataChange = "Y"  } # End of Switch 16 block         
            17 {Write-host 
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All Templates "
                                Write-Host "=========================================================================="                                Get-SCSMObjectTemplate | Select Displayname, ManagementPack |Sort Displayname | FT
                                Get-SCSMObjectTemplate  |  Select Displayname, FUllName |Sort Displayname | FT
                                $DataChange = "Y"  } # End of Switch 17 block
            18 {Write-host 
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All Views "
                                Write-Host "==========================================================================" 
                                Get-SCSMView | Select Displayname, ManagementPackName | Sort Displayname |  FT
                                $DataChange = "Y"  } # End of Switch 18 block
            19 {Write-host 
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All CI Groups "
                                Write-Host "==========================================================================" 
                                Get-SCSMGroup |  Select Displayname, FUllName |Sort Displayname | FT
                                $DataChange = "Y"  } # End of Switch 19 block
            20 {Write-host 
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All Queues "
                                Write-Host "==========================================================================" 
                                Get-SCSMQueue | Select Displayname, ManagementPackName | Sort Displayname | FT
                                $DataChange = "Y"  } # End of Switch 20 block
            21 {Write-host 
                                Write-Host
                                Write-Host "=========================================================================="
                                Write-Host "List of All Tasks "
                                Write-Host "==========================================================================" 
                                Get-SCSMTask | Select Displayname, Name | Sort Displayname | FT 
                                $DataChange = "Y"  } # End of Switch 21 block
            22 {Write-host -foregroundColor yellow "Input Specific Role Display Name (enter to use " -nonewline; write-host -foregroundColor green "`"$script:CurrentRole`"" -nonewline; Write-host -foregroundColor yellow "): " -nonewline; [string]$script:RoleInput = Read-host 
                                Get-AllRoles
                                Get-SpecificRole -InputRole $script:RoleInput
                                Get-ReportObject -InputReportType $script:CurrentRole
                                $DataChange = "Y" 
                                } # End of Switch 22 block
            23 {Write-host -foregroundColor yellow "Running Full Report for all Roles"
                                Get-AllRoles
                                Get-ReportObject -InputReportType "Full_SCSMReport"
                                $DataChange = "Y" } # End xof Switch 23 block

            x  {write-host -foregroundcolor red "Cancelled by operator."; Write-Host;  Write-Host; Exit} 
            y  {$DataChange = "Y"}
            default {write-host -foregroundcolor red "Incorrect number entered. Please choose again."; write-host ""}
             } #End of Switch 



     #---------------------------------------------------------------------------------------------------------------------
     # End of Second  DO For Menu System
     #--------------------------------------------------------------------------------------------------------------------    
    }  Until ($DataChange -eq "Y") 

    Write-Host -ForegroundColor green 
    Write-Host -ForegroundColor green 
    Write-Host -ForegroundColor green "==================================================================================================================="
    Write-Host -ForegroundColor green
    Write-Host -ForegroundColor Yellow " Repeat Script?  Y/N (default Y): "-nonewline ; $InputRepeatScript = Read-Host ; If ($InputRepeatScript  -eq "N") {$RepeatScript = "N"} Else {$RepeatScript = "Y"}
    Write-Host -ForegroundColor green
    Write-Host -ForegroundColor green "==================================================================================================================="
    Write-Host -ForegroundColor green 

#---------------------------------------------------------------------------------------------------------------------
# End of First DO For main repeating of the search 
#---------------------------------------------------------------------------------------------------------------------

 }  Until ($RepeatScript -eq "N") #End of First DO For main repeating of the search 

Write-Host -ForegroundColor green 
Write-Host -ForegroundColor green   "==================================================================================================================="
Write-Host -ForegroundColor green 
Write-Host -ForegroundColor green   " Script Complete"
Write-Host -ForegroundColor green 
Write-Host -ForegroundColor green   "==================================================================================================================="
Write-Host -ForegroundColor green 



    