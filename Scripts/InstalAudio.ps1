
(New-Object System.Net.WebClient).DownloadFile("http://rzr.to/surround-pc-download", "C:\ParsecTemp\Apps\razer-surround-driver.exe")

#Move extracts Razer Surround Files into correct location
cmd.exe /c '"C:\Program Files\7-Zip\7z.exe" x C:\ParsecTemp\Apps\razer-surround-driver.exe -oC:\ParsecTemp\Apps\razer-surround-driver -y' | Out-Null
	
	
$InstallerManifest = 'C:\ParsecTemp\Apps\razer-surround-driver\$TEMP\RazerSurroundInstaller\InstallerManifest.xml'
$regex = '(?<=<SilentMode>)[^<]*'
	(Get-Content $InstallerManifest) -replace $regex, 'true' | Set-Content $InstallerManifest -Encoding UTF8
	
	
	
	
			$OriginalLocation = Get-Location
		Set-Location -Path 'C:\ParsecTemp\Apps\razer-surround-driver\$TEMP\RazerSurroundInstaller\'
		Start-Process RzUpdateManager.exe
		Set-Location $OriginalLocation
		Set-Service -Name audiosrv -StartupType Automatic

