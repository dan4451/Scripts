﻿Start-Process powershell -Credential ad\darryl-priv -ArgumentList '-noprofile -command &{Start-Process mmc -verb runas}'