$LocalPath = ($MyInvocation.MyCommand.Path).replace("StartES.ps1", "")



Start-process powershell.exe -windowstyle hidden $LocalPath'EaglesoftRunas.ps1' -Verb RunAs