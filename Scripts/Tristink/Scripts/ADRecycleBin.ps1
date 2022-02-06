#Shows the DN of our AD Recycle Bin
get-addomain | select DeletedObjectsContainer

#Shows deleted items in our AD Recycle Bin | When an object is deleted, it is moved to this container pretty much as is. For our purposes, Active Directory will add two key properties: IsDeleted and LastKnownParent.
get-adobject -filter 'objectclass -eq "user" -AND IsDeleted -eq $True' -IncludeDeletedObjects -properties IsDeleted,LastKnownParent | Format-List Name,IsDeleted,LastKnownParent,DistinguishedName

#Restores Filtered object and the path that it will be restored to
get-adobject -filter 'name -like "cool*"' -IncludeDeletedObjects | Restore-ADObject –TargetPath "OU=Service Accounts,OU=TriLinkSD,DC=trilinksd,DC=local" -passthru

#Show who deleted an ad object (run on DC)
Get-EventLog -LogName Security | Where-Object {$_.EventID -eq 4726} | Select-Object -Property *