#remove old adobe apps

#$x=0
#$y=1
#$z=($x+$y)



$x1 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{554BB9CF-1626-4DB0-93C7-8B3B1AC5BB28}"'
$x2 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{6587559E-D025-41CD-9BDD-081B5DAAA739}"'
$x3 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{28CC4C4E-73C5-49C7-B8BA-016E767F07D0}"'
$x4 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{52B2164D-D4B7-4746-B94F-566A43FB7876}"'
$x5 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{C996B92D-6E8E-41D1-A5DF-FA79FB446ED7}"'
$x6 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{A8C5527B-1602-4CA7-9729-5193E623151D}"'
$x7 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{E6694AFA-DAF9-4A86-8D6A-AD80615F304C}"'
$x8 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{2A93723A-7F84-417D-BEFA-E5449BABAEA7}"'
$x9 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{F10E0DC8-E945-44A5-A3EB-EBA7AE30AB24}"'
$x10 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{15FC1918-0890-482C-8628-CE9415D11455}"'
$x11 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{9461E5A7-4CF0-4781-B421-5A61B4F688A0}"'
$x12 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{79850516-92EE-49F2-9A42-139F7083DE05}"'
$x13 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{5854B3A3-466B-41A2-9B8A-F1FFDBF6FB63}"'
$x14 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{FAF57B00-22E3-4DEC-88FE-C35A9716C1C3}"'
$x15 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{7011EF61-E4A7-42E2-A3F1-BAC881D59EC6}"'
$x16 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{EA702371-33F4-42A0-8861-CA11132B779D}"'
$x17 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{BE746BC1-1F9A-46B5-8E88-C063D00ADDC8}"'
$x18 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{7D2F23D1-80B8-45B7-9CF9-9B4F002B4D22}"'
$x19 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{BE35DDF1-F356-416B-9A75-0B6AADCC7A0A}"'
$x20 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{14C41842-168E-4D7C-A13C-17A9990A4AEB}"'
$x21 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{E752F5A2-278D-482F-9145-9E16799E6618}"'
$x22 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{E0C5AF53-D2D5-4E78-A18D-C1A5820D6ED5}"'
$x23 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{AC76BA86-1033-FFFF-7760-0C0F074E4100}"'
$x24 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{DDE8B528-E8F3-4E06-9DDB-7F2A6013E441}"'
$x25 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{49F88092-C4F8-4D42-AB85-0614EC5430D3}"'
$x26 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{B3944DD2-31AF-490C-ADD5-514C11EFBDE8}"'
$x27 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{E7865423-CBDF-43C4-976B-B8A7EF702DB9}"'
$x28 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{CF147AC7-3EB1-41F2-98CB-6CB4FB1E1D2D}"'
$x29 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{6D6789E8-FE73-4DB4-A6F5-505B5F261C87}"'
$x30 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{A12F20A9-24EC-4F4D-B1D6-F5030DA00909}"'
$x31 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{57F775F9-E051-41A1-816B-BBFD57979B10}"'
$x32 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{452E28F9-4542-45BB-8758-467781E34959}"'
$x33 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{0328074C-F419-4BF8-ACDB-BB5394EB9E99}"'
$x34 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{B895D50D-513E-4DF7-A24F-906E54A0DD33}"'
$x35 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{3B528B0D-D2D9-4B00-9BD3-235DDCDC696F}"'
$x36 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{C179E0FD-3275-462F-8F1A-71C6CB02B56C}"'
$x37 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{BF7269FD-8F2B-411C-8761-0B79806701B9}"'
$x38 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{87C03E4E-C2BC-4034-A3A0-737DC9C284C3}"'
$x39 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{5E41179E-08FE-405F-9966-54B2B9CE3622}"'
$x40 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{BA573BFE-83B4-11E3-93D2-D231FEB1DC81}"'
$x41 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{554BB9CF-1626-4DB0-93C7-8B3B1AC5BB28}"'
$x42 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{1EBA3852-128B-46C0-A014-E968E5A8FDE5}"'
$x43 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{C22CDB20-90DB-453E-8853-276480B9B973}"'
$x44 = Get-WmiObject win32_product -Filter 'IdentifyingNumber = "{B18F03D7-B6FA-4A72-A885-FBDBA0D5AC9D}"'




$x1.Uninstall()
$x2.Uninstall()
$x3.Uninstall()
$x4.Uninstall()
$x5.Uninstall()
$x6.Uninstall()
$x7.Uninstall()
$x8.Uninstall()
$x9.Uninstall()
$x10.Uninstall()
$x11.Uninstall()
$x12.Uninstall()
$x13.Uninstall()
$x14.Uninstall()
$x15.Uninstall()
$x16.Uninstall()
$x17.Uninstall()
$x18.Uninstall()
$x19.Uninstall()
$x20.Uninstall()
$x21.Uninstall()
$x22.Uninstall()
$x23.Uninstall()
$x24.Uninstall()
$x25.Uninstall()
$x26.Uninstall()
$x27.Uninstall()
$x28.Uninstall()
$x29.Uninstall()
$x30.Uninstall()
$x31.Uninstall()
$x32.Uninstall()
$x33.Uninstall()
$x34.Uninstall()
$x35.Uninstall()
$x36.Uninstall()
$x37.Uninstall()
$x38.Uninstall()
$x39.Uninstall()
$x40.Uninstall()
$x41.Uninstall()
$x42.Uninstall()
$x43.Uninstall()
$x44.Uninstall()




<#
IdentifyingNumber : {B18F03D7-B6FA-4A72-A885-FBDBA0D5AC9D}
Name              : Illustrator CC 2017
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Illustrator CC 2017
IdentifyingNumber : {C22CDB20-90DB-453E-8853-276480B9B973}
Name              : Premiere Pro CC 2017
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Premiere Pro CC 2017
IdentifyingNumber : {1EBA3852-128B-46C0-A014-E968E5A8FDE5}
Name              : Muse CC 2017
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Muse CC 2017
IdentifyingNumber : {554BB9CF-1626-4DB0-93C7-8B3B1AC5BB28}
Name              : Lightroom CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Lightroom CC 2015

IdentifyingNumber : {BA573BFE-83B4-11E3-93D2-D231FEB1DC81}
Name              : Adobe Scout CC
Vendor            : Adobe Systems Incorporated
Version           : 1.1.3.354121
Caption           : Adobe Scout CC

IdentifyingNumber : {5E41179E-08FE-405F-9966-54B2B9CE3622}
Name              : Extension Manager CC
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Extension Manager CC

IdentifyingNumber : {87C03E4E-C2BC-4034-A3A0-737DC9C284C3}
Name              : InCopy CC 13.0.1
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : InCopy CC 13.0.1

IdentifyingNumber : {BF7269FD-8F2B-411C-8761-0B79806701B9}
Name              : Photoshop CC 2017
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Photoshop CC 2017

IdentifyingNumber : {C179E0FD-3275-462F-8F1A-71C6CB02B56C}
Name              : Media Encoder CC 12.0.0
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Media Encoder CC 12.0.0

IdentifyingNumber : {3B528B0D-D2D9-4B00-9BD3-235DDCDC696F}
Name              : Gaming SDK 1.4
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Gaming SDK 1.4

IdentifyingNumber : {B895D50D-513E-4DF7-A24F-906E54A0DD33}
Name              : InDesign 13.0.1
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : InDesign 13.0.1

IdentifyingNumber : {0328074C-F419-4BF8-ACDB-BB5394EB9E99}
Name              : Bridge CC 8.0.1
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Bridge CC 8.0.1

IdentifyingNumber : {452E28F9-4542-45BB-8758-467781E34959}
Name              : Prelude CC 7.0.0
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Prelude CC 7.0.0

IdentifyingNumber : {57F775F9-E051-41A1-816B-BBFD57979B10}
Name              : InCopy CC 2017
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : InCopy CC 2017

IdentifyingNumber : {A12F20A9-24EC-4F4D-B1D6-F5030DA00909}
Name              : Character Animator CC 1.1.0
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Character Animator CC 1.1.0

IdentifyingNumber : {6D6789E8-FE73-4DB4-A6F5-505B5F261C87}
Name              : Acrobat DC 2015.10
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Acrobat DC 2015.10

IdentifyingNumber : {FAF57B00-22E3-4DEC-88FE-C35A9716C1C3}
Name              : After Effects CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : After Effects CC 2015

IdentifyingNumber : {7011EF61-E4A7-42E2-A3F1-BAC881D59EC6}
Name              : Fuse CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Fuse CC 2015

IdentifyingNumber : {EA702371-33F4-42A0-8861-CA11132B779D}
Name              : Edge Animate CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Edge Animate CC 2015

IdentifyingNumber : {BE746BC1-1F9A-46B5-8E88-C063D00ADDC8}
Name              : Animate CC 2015 and Mobile Device Packaging
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Animate CC 2015 and Mobile Device Packaging

IdentifyingNumber : {7D2F23D1-80B8-45B7-9CF9-9B4F002B4D22}
Name              : Media Encoder CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Media Encoder CC 2015

IdentifyingNumber : {BE35DDF1-F356-416B-9A75-0B6AADCC7A0A}
Name              : Illustrator CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Illustrator CC 2015

IdentifyingNumber : {14C41842-168E-4D7C-A13C-17A9990A4AEB}
Name              : Photoshop CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Photoshop CC 2015

IdentifyingNumber : {E752F5A2-278D-482F-9145-9E16799E6618}
Name              : InCopy CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : InCopy CC 2015

IdentifyingNumber : {E0C5AF53-D2D5-4E78-A18D-C1A5820D6ED5}
Name              : Audition CC 2015
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0
Caption           : Audition CC 2015

IdentifyingNumber : {DDE8B528-E8F3-4E06-9DDB-7F2A6013E441}
Name              : Acrobat DC 17.0
Vendor            : Adobe Systems Incorporated
Version           : 1.0.0000
Caption           : Acrobat DC 17.0
#>