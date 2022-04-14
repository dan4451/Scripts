#Use Connect-MSGraph first

$Devices = Get-IntuneManagedDevice -Filter "contains(deviceName,'SD-IPAD-EHS-L01')"
ForEach ($Device in $Devices){
    $DevID=$device.managedDeviceId
    Write-Host "Sending Sync request to Device with DeviceID $DevID" 
    Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $device.managedDeviceId 
    }