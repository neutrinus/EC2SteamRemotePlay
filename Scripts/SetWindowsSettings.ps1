

#disable IE security
Set-Itemproperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -name IsInstalled -value 0 -force | Out-Null
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name IsInstalled -Value 0 -Force | Out-Null
Stop-Process -Name Explorer -Force

#Set time from ntp
Set-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value NTP | Out-Null
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate -Name Start -Value 00000003 | Out-Null

# disable new network windows prompt
if((Test-RegistryValue -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -Value NewNetworkWindowOff)-eq $true) {} Else {new-itemproperty -path HKLM:\SYSTEM\CurrentControlSet\Control\Network -name "NewNetworkWindowOff" | Out-Null}

#Enable Pointer Precision 
Set-Itemproperty -Path 'HKCU:\Control Panel\Mouse' -Name MouseSpeed -Value 1 | Out-Null

#enable Mouse Keys
set-Itemproperty -Path 'HKCU:\Control Panel\Accessibility\MouseKeys' -Name Flags -Value 63 | Out-Null



#disable shutdown start menu
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name NoClose -Value 1 | Out-Null

#Sets all applications to force close on shutdown
if (((Get-Item -Path "HKCU:\Control Panel\Desktop").GetValue("AutoEndTasks") -ne $null) -eq $true) 
	{Set-ItemProperty -path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"
}
Else {New-ItemProperty -path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"}


#show hidden items
set-itemproperty -path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1 | Out-Null


#show file extensions
Set-itemproperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -name HideFileExt -Value 0 | Out-Null



function Test-RegistryValue {
# https://www.jonathanmedd.net/2014/02/testing-for-the-presence-of-a-registry-key-and-value.html
	param (
			[parameter(Mandatory=$true)]
			[ValidateNotNullOrEmpty()]$Path,

			[parameter(Mandatory=$true)]
			[ValidateNotNullOrEmpty()]$Value
	      )
		try {
			Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
				return $true
		}
	catch {
		return $false
	}
}


#set update policy
if((Test-RegistryValue -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -value 'DoNotConnectToWindowsUpdateInternetLocations') -eq $true) {Set-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "DoNotConnectToWindowsUpdateInternetLocations" -Value "1" | Out-Null} else {new-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "DoNotConnectToWindowsUpdateInternetLocations" -Value "1" | Out-Null}
if((Test-RegistryValue -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -value 'UpdateServiceURLAlternative') -eq $true) {Set-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "UpdateServiceURLAlternative" -Value "http://intentionally.disabled" | Out-Null} else {new-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "UpdateServiceURLAlternative" -Value "http://intentionally.disabled" | Out-Null}
if((Test-RegistryValue -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -value 'WUServer') -eq $true) {Set-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "WUServer" -Value "http://intentionally.disabled" | Out-Null} else {new-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "WUServer" -Value "http://intentionally.disabled" | Out-Null}
if((Test-RegistryValue -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -value 'WUSatusServer') -eq $true) {Set-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "WUSatusServer" -Value "http://intentionally.disabled" | Out-Null} else {new-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name "WUSatusServer" -Value "http://intentionally.disabled" | Out-Null}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "AUOptions" -Value 1 | Out-Null
if((Test-RegistryValue -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -value 'UseWUServer') -eq $true) {Set-itemproperty -path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 1 | Out-Null} else {new-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -Value 1 | Out-Null}


#disable logout start menu
if((Test-RegistryValue -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Value StartMenuLogOff )-eq $true) {Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 | Out-Null} Else {New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name StartMenuLogOff -Value 1 | Out-Null}


#disable lock start menu
if((Test-Path -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System) -eq $true) {} Else {New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies -Name Software | Out-Null}
if((Test-RegistryValue -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Value DisableLockWorkstation) -eq $true) {Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 | Out-Null } Else {New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name DisableLockWorkstation -Value 1 | Out-Null}


#disable recent start menu items
New-Item -path HKLM:\SOFTWARE\Policies\Microsoft\Windows -name Explorer
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -PropertyType DWORD -Name HideRecentlyAddedApps -Value 1



#Disables Server Manager opening on Startup
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask | Out-Null

#AWS Clean up Desktop Items
Remove-item -path "$path\EC2 Feedback.Website"
Remove-Item -Path "$path\EC2 Microsoft Windows Guide.website"

#cleanup recent files
Remove-item "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force | Out-Null


