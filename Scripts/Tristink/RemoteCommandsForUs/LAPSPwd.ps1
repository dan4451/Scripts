#DAN FRANCIA 12/6/2021
##################################################
#### Env Variables ###############################
##################################################

$user = $env:USERNAME
$env:ok = @"
                             
  ,ad8888ba,   88      a8P   
 d8"'    `"8b  88    ,88'    
d8'        `8b 88  ,88"      
88          88 88,d88'       
88          88 8888"88,      
Y8,        ,8P 88P   Y8b     
 Y8a.    .a8P  88     "88,   
  `"Y8888Y"'   88       Y8b 
"@
$env:notok = @"
                                                                
888b      88                         ,ad8888ba,   88      a8P   
8888b     88              ,d        d8"'    `"8b  88    ,88'    
88 `8b    88              88       d8'        `8b 88  ,88"      
88  `8b   88  ,adPPYba, MM88MMM    88          88 88,d88'       
88   `8b  88 a8"     "8a  88       88          88 8888"88,      
88    `8b 88 8b       d8  88       Y8,        ,8P 88P   Y8b     
88     `8888 "8a,   ,a8"  88,       Y8a.    .a8P  88     "88,   
88      `888  `"YbbdP"'   "Y888      `"Y8888Y"'   88       Y8b  
"@

##################################################
#### ADM Check ###################################
##################################################
if($user -like "adm.*"){start-process powershell.exe -argumentlist '-command Write-host $($env:ok)"`n`n Checked that account running script is adm." -ForegroundColor Green; start-sleep -s 3'}
else{start-process powershell.exe -argumentlist '-command Write-host $($env:notok)"`n`nThis script needs to be run as your adm. account." -ForegroundColor Red; start-sleep -s 10'}

#sleep 3 seconds
start-sleep -s 3
##################################################
#### Forms Config ################################
##################################################
#import form libraries from .net
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Draws the initial form

$form = New-Object System.Windows.Forms.Form
$form.Text = 'LAPS Password Finder'
$form.Size = New-Object System.Drawing.Size(510,510)
$form.StartPosition = 'CenterScreen'

#OK Button

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(300,50)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

#Cancel Button

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,90)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

#Label above Textbox1

$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = 'Please enter the name of the computer:'
$form.Controls.Add($label1)

#Textbox accepting computer name

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(10,40)
$textBox1.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox1)

#Trilink Background Image

$img = [System.Drawing.Image]::Fromfile('.\TriLink_Logo.jpg')
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = $img.Size.Width
$pictureBox.Height = $img.Size.Height
$pictureBox.Image = $img
$form.controls.add($pictureBox)

#keeps window on top
$form.Topmost = $true
#shows the form
$result = $form.ShowDialog()

##################################################
#### Logic Methods ###############################
##################################################

#method for retrieved LAPS password
function Get-LapsPassword
{
#defines a variable that will grab the LAPS Password
$string= (Get-ADComputer $TargetPC -Properties *| select ms-Mcs-AdmPwd)
$data= $string.'ms-Mcs-AdmPwd'

#the form that will house the result
$form2 = New-Object System.Windows.Forms.Form
$form2.Text = 'Requested LAPS Password'
$form2.Size = New-Object System.Drawing.Size(510,510)
$form2.StartPosition = 'CenterScreen'

#the actual printed LAPS password on the form
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,20)
$label1.Size = New-Object System.Drawing.Size(300,20)
$label1.font = 'MS Reference Sans Serif, 14'
$label1.Text = $data
$form2.Controls.Add($label1)
[void]$form2.ShowDialog()
}

#When the user clicks ok, the computername is assigned to $targetpc, 
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $TargetPC = $textBox1.Text
try{
    Get-LapsPassword
}
catch
{
   start-process powershell.exe -argumentlist '-command Write-host "Computer does not exist in AD." -ForegroundColor Red; start-sleep -s 10'
    }

    }