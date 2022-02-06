$computerName = "GLI-LT-07"
$wmi = [WMI] ""
get-wmiobject Win32_UserProfile -computername $computerName | foreach-object {
  $userAccount = [WMI] ("\\$computerName\root\cimv2:Win32_SID.SID='{0}'" -f $_.SID)
  $userName = "{0}\{1}" -f $userAccount.ReferencedDomainName,$userAccount.AccountName
  new-object PSObject -property @{
    "Name" = $userName
    "LastUseTime" = $wmi.ConvertToDatetime($_.LastUseTime)
    "Loaded" = $_.Loaded
  }
}

# after getting list of profiles from the computer quiered above you can use this line to delete the profile:

#  (Get-WmiObject win32_userprofile -computer GLI-LT-07 | where-Object { $_.LocalPath -eq 'c:\users\dfrancia'}).Delete()