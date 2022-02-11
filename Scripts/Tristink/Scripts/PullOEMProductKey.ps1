$computers= get-adobject -filter * -searchbase 'OU=Servers,OU=Computers,OU=TriLinkSD,DC=trilinksd,DC=local'

foreach($computer in $computers){
invoke-command -computername $computer.name -scriptblock{get-ciminstance Win32_computersystem}
}