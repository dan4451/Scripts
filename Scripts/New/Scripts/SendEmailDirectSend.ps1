## Build parameters
$mailParams = @{
    SmtpServer                 = 'trilinkbiotech-com.mail.protection.outlook.com'
    Port                       = '25'
    UseSSL                     = $true   
    From                       = 'dfrancia@trilinkbiotech.com'
    To                         = 'dfrancia@trilinkbiotech.com'
    Subject                    = "Direct Send $(Get-Date -Format g)"
    Body                       = 'This is a test email using Direct Send'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the email
Send-MailMessage @mailParams