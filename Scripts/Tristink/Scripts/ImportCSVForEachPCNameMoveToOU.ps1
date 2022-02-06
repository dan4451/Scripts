#imports a csv and does somthing with the data. The columns in the csv are specified by the $($_.'columnName')
#
#Dan Francia 
#

#path to the CSV here:
$csvPath = 'C:\Users\daniel.francia\OneDrive - Maravai Life Sciences, Inc\Documents\TriLinkUsersAndTheirDepartments.csv'

Import-Csv -Path $csvPath | ForEach-Object{
    
    #Print associated User
    Write-Host  "$($_.FullName)" -ForegroundColor Yellow -NoNewline;
    Write-Host " is the user's Name, " -NoNewline


    #Print PC name to be moved
    Write-Host "SD-DT-$($_.PCName)" -ForegroundColor Yellow -NoNewline;
    Write-Host " is the PC they use, and " -NoNewline



    #Print The OU the computer is moving to
    Write-Host "$($_.OU)" -ForegroundColor Yellow -NoNewline;
    Write-Host "is the OU the computer needs to go in!"
    
    $pcname = "SD-DT-$($_.PCName)"

    Try {
    Get-ADComputer SD-SF-$($_.PCName) | Move-ADObject -TargetPath $($_.OU)
    Write-Host "Computer is found. Moving " -ForegroundColor Blue -BackgroundColor DarkYellow -NoNewline
    Write-Host "$pcname" -ForegroundColor Blue -BackgroundColor DarkYellow -NoNewline
    Write-Host " to" -ForegroundColor Blue -BackgroundColor DarkYellow -NoNewline
    Write-Host " $($_.OU)." -ForegroundColor Blue -BackgroundColor DarkYellow
        }

    Catch  {
       Write-Host $_ -ForegroundColor Magenta 
       [PSCustomObject]@{'pcname'=$pcname} | Export-csv -Path 'C:\users\daniel.francia\OneDrive - Maravai Life Sciences, Inc\Documents\Exceptions.csv' -Append -Force
         }

    }



