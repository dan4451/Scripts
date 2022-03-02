#sets default file associations

#loads the necessary part of the .NET Framework into memory | and suppress success message
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

#launches the InputBox, which is a static method of the Visual Basic Interaction class. The method accepts three parameters, in this order: the prompt, the title, and the default value
$computername = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a computer name", "Computer", "$env:computername")

Invoke-Command $computername -ScriptBlock { cmd dism /online /import-defaultappassociations:"\\trilinksd.local\SYSVOL\trilinksd.local\XMLs\Staff PC\FileAssociations.xml"}