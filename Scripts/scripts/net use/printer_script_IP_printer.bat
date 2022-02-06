

cscript "C:\Windows\System32\Printing_Admin_Scripts\en-US\prndrvr.vbs" -a -m "HP Universal Printing PCL 6" -i "C:\HP Universal Print Driver\pcl6-x64-6.0.0.18849\hpcu175u.inf"



cscript "C:\Windows\System32\Printing_Admin_Scripts\en-US\prnmngr.vbs" -a -p "HPLaserjet4240" -m "HP Universal Printing PCL 6" -r "216.87.102.16_1"


cscript %WINDIR%\System32\Printing_Admin_Scripts\en-US\Prnport.vbs -a -r IP_216.87.102.16 -h 216.87.102.16 -o raw -n 9100


