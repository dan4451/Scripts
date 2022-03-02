#ESD is a compressed encrypted file.
#Inside it's contents is located the .wim file.
#Commands using a cmd prompt with Admin privileges, where X: is the windows installation boot media letter.
#IT WILL NOT WORK WITH THE BOOT DRIVE LETTER that Windows Installation Boot Media creates (usually X:), you will need to have a windows media installation inserted ou mounted.

# 1. List installations avaliable inside .esd file:

dism /Get-WimInfo /WimFile:X:\sources\install.esd


# 2. After running command above you will get a list of Windows versions avaliable inside .esd file each one with a number.


# 3. Extract .wim file from .esd file according to the Windows edition you choose in the list from command above and change-it in the part of the command
# /SourceIndex:X where X is the number of the Installation version you choose in the list:

dism /Export-Image /SourceImageFile:install.esd /SourceIndex:1 /DestinationImageFile:install.wim /Compress:max /CheckIntegrity

# *PLUS* Create Windows ISO:

oscdimg -u2 -m -bC:\win10\boot\etfsboot.com C:\Win10 C:\Win10.iso