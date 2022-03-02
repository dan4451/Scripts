#Remove Unwanted Windows Apps
Write-Output "Removing Apps"

$apps = "Microsoft.549981C3F5F10_8wekyb3d8bbwe","Microsoft.People_8wekyb3d8bbwe","Microsoft.WindowsFeedback*","Microsoft.windowscommunication*", "Microsoft.XboxIdentityProvider","Microsoft.XboxGameCallableUI","Microsoft.Windows.PeopleExperienceHost","Microsoft.Windows.ParentalControls","Microsoft.SkypeApp","Microsoft.ZuneVideo","Microsoft.ZuneMusic","Microsoft.YourPhone","Microsoft.XboxSpeechToTextOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxGameOverlay","Microsoft.XboxApp","Microsoft.Xbox.TCUI","Microsoft.Wallet","Microsoft.People","Microsoft.MicrosoftSolitaireCollection","Microsoft.MicrosoftOfficeHub","Microsoft.Getstarted","Microsoft.GetHelp"

ForEach ($app in $apps)
{
  Write-host "Uninstalling:" $app
  Get-AppxPackage -allusers $app | Remove-AppxPackage
}