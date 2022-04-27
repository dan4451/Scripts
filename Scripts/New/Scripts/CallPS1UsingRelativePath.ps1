#After much trial and error, I've come up with a solution:

#Create a shortcut with this (edited for your .ps1) to have scrips run as admin relative to any directory:

CMD /C PowerShell "SL -PSPath '%CD%'; $Path = (GL).Path; SL ~; Start PowerShell -Verb RunAs -Args \""SL -PSPath '"$Path"'; & '".\YourScriptHere.ps1"'"\""
#You'll have to empty the shortcut's "Start in" field to have its relative path be set as the working directory.

#Or, here's a script that will generate one of these shortcuts for each .ps1 in a directory (with "Start in" already cleared):

(GCI | Where-Object {$_.Extension -eq ".ps1"}).Name | ForEach-Object {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut((GL).Path+"\$_ Run.lnk")
    $Shortcut.TargetPath = 'CMD'
    $Shortcut.Arguments = "/C PowerShell `"SL -PSPath `'%CD%`'; `$Path = (GL).Path; SL ~; Start PowerShell -Verb RunAs -Args \`"`"SL -PSPath `'`"`$Path`"`'; & `'`".\$_`"`'`"\`"`""    
    $Shortcut.IconLocation = 'PowerShell.exe'
    $Shortcut.Save()
}