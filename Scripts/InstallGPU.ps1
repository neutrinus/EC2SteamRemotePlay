
Write-Output "Installing GPU drivers"

# remove old windows gpu drivers
takeown /f C:\Windows\System32\Drivers\BasicDisplay.sys
cacls C:\Windows\System32\Drivers\BasicDisplay.sys /G Administrator:F
del C:\Windows\System32\Drivers\BasicDisplay.sys
 
 
 
# Disable Devices
Start-Process -FilePath "C:\ParsecTemp\Devcon\devcon.exe" -ArgumentList '/r disable "HDAUDIO\FUNC_01&VEN_10DE&DEV_0083&SUBSYS_10DE11A3*"'
Get-PnpDevice| where {$_.friendlyname -like "Generic Non-PNP Monitor" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
Get-PnpDevice| where {$_.friendlyname -like "Microsoft Basic Display Adapter" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
#Start-Process -FilePath "C:\ParsecTemp\Devcon\devcon.exe" -ArgumentList '/r disable "PCI\VEN_1013&DEV_00B8*"'

