#DAN FRANCIA 12/6/2021
$user = $env:USERNAME
if($user -like "adm.*"){start-process powershell.exe -argumentlist '-command Write-host "Checked that account running script is adm." -ForegroundColor Green; start-sleep -s 6'}
else{start-process powershell.exe -argumentlist '-command Write-host "This script needs to be run as your adm. account." -ForegroundColor Red; start-sleep -s 10'}


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'RENAME A REMOTE COMPUTER'
$form.Size = New-Object System.Drawing.Size(510,510)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(300,50)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,90)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = 'Please enter the name of the computer:'
$form.Controls.Add($label1)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(10,40)
$textBox1.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(10,60)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'Please enter the New PC Name:'
$form.Controls.Add($label2)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(10,80)
$textBox2.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox2)

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(10,100)
$label3.Size = New-Object System.Drawing.Size(280,20)
$label3.Text = 'Please enter your domain admin user account:'
$form.Controls.Add($label3)

$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(10,120)
$textBox3.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox3)

$img = [System.Drawing.Image]::Fromfile('\\server6\shared\it\dan\RemoteCommandsForUs\TriLink_Logo.jpg')
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = $img.Size.Width
$pictureBox.Height = $img.Size.Height
$pictureBox.Image = $img
$form.controls.add($pictureBox)

$form.Topmost = $true

#$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox1.Text
    $y = $textBox2.Text
    $z = $textBox3.Text

    $TargetPC = $x
    $NewName = $y
    $AdminCredential = $z
    }

if(test-connection $targetpc)
{
    invoke-command -ComputerName $TargetPC -ScriptBlock { Rename-Computer $using:NewName -DomainCredential $using:AdminCredential }
   start-process powershell.exe -argumentlist '-command Write-Host "Command executed successfully. Ensure the computer is restarted for name change to take effect." -ForegroundColor Yellow; start-sleep -s 10'
}
else{
   start-process powershell.exe -argumentlist '-command Write-host "The target computer may be powered off or the network cable is unplugged, verify and try again." -ForegroundColor Red; start-sleep -s 10'
    }