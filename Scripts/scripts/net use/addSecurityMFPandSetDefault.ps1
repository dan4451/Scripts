(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\adb-ps-01\BatesMFP")

Start-Sleep -s 1

(New-Object -ComObject WScript.Network).SetDefaultPrinter('\\adb-ps-01\BatesMFP')