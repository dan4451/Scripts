
$x1 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{AC76BA86-7AD7-1033-7B44-AC0F074E4100}"'

$x1.Uninstall()