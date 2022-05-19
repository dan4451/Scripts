dism.exe /Online /add-provisionedappxpackage /packagepath:\\trilinksd.local\SYSVOL\trilinksd.local\Apps\Microsoft.WindowsCalculator_2020.2103.8.0_neutral___8wekyb3d8bbwe.AppxBundle /skiplicense
timeout /t 15
dism.exe /Online /add-provisionedappxpackage /packagepath:\\trilinksd.local\SYSVOL\trilinksd.local\Apps\Microsoft.MicrosoftStickyNotes_3.7.106.0_neutral___8wekyb3d8bbwe.AppxBundle /skiplicense