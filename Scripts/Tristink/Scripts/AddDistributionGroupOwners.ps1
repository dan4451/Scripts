﻿Get-DistributionGroup | Where-Object name -like *Rees* | foreach $_ {Set-DistributionGroup -Identity $_.name -ManagedBy @{Add="rkeenan@trilinkbiotech.com","tmiller@trilinkbiotech.com"}}