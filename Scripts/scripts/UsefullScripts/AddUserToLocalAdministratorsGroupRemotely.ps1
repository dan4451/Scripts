Invoke-Command -ComputerName CHS-WL-3476 -ScriptBlock {net localgroup Administrators "ad\Pattersonserviceacco" /add}
