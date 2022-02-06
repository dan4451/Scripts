#generate a key


$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file E:\Scripts\new\PR\aes.key


#Now, we create a password file, however we use the -key parameter to specify that
# we want to use a key then input the location of the key file. 
#Then we create the password file. In this example we’ll output the password file to our C:\Users\dfrancia\Documents\RunAsScripts directory: 

(get-credential).Password | ConvertFrom-SecureString -key (get-content E:\Scripts\new\PR\aes.key) | set-content "E:\Scripts\new\PR\password.txt"


#This next part will recall the password from the file

$password = Get-Content E:\Scripts\new\PR\password.txt | ConvertTo-SecureString -Key (Get-Content E:\Scripts\new\PR\aes.key)
$credential = New-Object System.Management.Automation.PsCredential("dan-priv",$password)


$credential
