Import-Csv -Path “\\ad\ubdfs\its\dan\PriorityBackups.csv” | ForEach-Object { 

    Write-Warning "Backing up $($_.Username) on $($_.Computername) to \\ad\ubdfs\its backups."



$FoldersToCopy = @(
    'Desktop'
    #'Downloads'
    #'Favorites'
    'Documents'
    #'Pictures'
    #'Videos'
    #'AppData\Local\Google'
    )
$Computer = $_.ComputerName
$User = $_.Username    
$SourceRoot      = "\\$Computer\c$\Users\$User"
$DestinationRoot = "\\ad\ubdfs\its backups\$Computer-$User"

foreach( $Folder in $FoldersToCopy ){
    $Source      = Join-Path -Path $SourceRoot -ChildPath $Folder
    $Destination = Join-Path -Path $DestinationRoot -ChildPath $Folder

    if( -not ( Test-Path -Path $Source -PathType Container ) ){
        Write-Warning "Could not find path`t$Source"
        Write-Warning ($_.Computer + "Not rechable")
        return
        }
      else {
      Robocopy.exe $Source $Destination /E /IS /NP /NFL /XF *.pst /R:1
  }
    }
    }