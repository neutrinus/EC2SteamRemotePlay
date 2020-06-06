
Function TestCredential {
	param
		(
		 [PSCredential]$Credential
		)
		try {
			Start-Process -FilePath cmd.exe /c -Credential ($Credential)
		}
	Catch {
		If ($Error[0].Exception.Message) {
			$Error[0].Exception.Message
				Throw
		}
	}
}

function Set-AutoLogon {
	[CmdletBinding(SupportsShouldProcess)]
		param
			(
			 [PSCredential]$Credential
			)
			Try {
				if ($Credential.GetNetworkCredential().Domain) {
					$DefaultDomainName = $Credential.GetNetworkCredential().Domain
				}
				elseif ((Get-WMIObject Win32_ComputerSystem).PartOfDomain) {
					$DefaultDomainName = "."
				}
				else {
					$DefaultDomainName = ""
				}

				if ($PSCmdlet.ShouldProcess(('User "{0}\{1}"' -f $DefaultDomainName, $Credential.GetNetworkCredential().Username), "Set Auto logon")) {
					Write-Verbose ('DomainName: {0} / UserName: {1}' -f $DefaultDomainName, $Credential.GetNetworkCredential().Username)
						Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "AutoAdminLogon" -Value 1
						Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "DefaultDomainName" -Value ""
						Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "DefaultUserName" -Value $Credential.UserName
						Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "AutoLogonCount" -ErrorAction SilentlyContinue
						Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "DefaultPassword" -ErrorAction SilentlyContinue
						$private:LsaUtil = New-Object ComputerSystem.LSAutil -ArgumentList "DefaultPassword"
						$LsaUtil.SetSecret($Credential.GetNetworkCredential().Password)
						"Auto Logon Configured"
						Remove-Variable Credential
				}
			}
	Catch {
		$Error[0].Exception.Message
			Throw
	}
}


Function GetInstanceCredential {

	Try {
		$Credential = Get-Credential -Credential $null
			Try {
				TestCredential -Credential $Credential
			}
		Catch {
			"Credentials Incorrect"
		}
		Try {
			Set-AutoLogon -Credential $Credential
		}
		Catch {
			$Error[0].Exception
				"Retry?"
				$ReadHost = Read-Host "(Y/N)"
				Switch ($ReadHost) 
				{
					Y {
						GetInstanceCredential 
					}
					N {
					}
				}
		}

	}
	Catch {
		"You pressed cancel, retry?"
			$ReadHost = Read-Host "(Y/N)"
			Switch ($ReadHost) 
			{
				Y {
					GetInstanceCredential
				}
				N {
				}
			}
	}
}
GetInstanceCredential

				





#download-files-S3
function download-resources {
		(New-Object System.Net.WebClient).DownloadFile("https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe", "C:\ParsecTemp\Apps\directx_Jun2010_redist.exe") 
		ProgressWriter -Status "Downloading Devcon" -PercentComplete $PercentComplete
		(New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/parsec-files-ami-setup/Devcon/devcon.exe", "C:\ParsecTemp\Devcon\devcon.exe")
		ProgressWriter -Status "Downloading Parsec" -PercentComplete $PercentComplete
		(New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\ParsecTemp\Apps\parsec-windows.exe")
		ProgressWriter -Status "Downloading GPU Updater" -PercentComplete $PercentComplete
		(New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/parseccloud/image/parsec+desktop.png", "C:\ParsecTemp\parsec+desktop.png")
		(New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/parseccloud/image/white_ico_agc_icon.ico", "C:\ParsecTemp\white_ico_agc_icon.ico")
		(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/jamesstringerparsec/Cloud-GPU-Updater/master/GPUUpdaterTool.ps1", "$env:APPDATA\ParsecLoader\GPUUpdaterTool.ps1")
		ProgressWriter -Status "Downloading Google Chrome" -PercentComplete $PercentComplete
		(New-Object System.Net.WebClient).DownloadFile("https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi", "C:\ParsecTemp\Apps\googlechromestandaloneenterprise64.msi")


		start-process -filepath "C:\Windows\System32\msiexec.exe" -ArgumentList '/qn /i "C:\ParsecTemp\Apps\googlechromestandaloneenterprise64.msi"' -Wait
		ProgressWriter -Status "Installing DirectX June 2010 Redist" -PercentComplete $PercentComplete
		Start-Process -FilePath "C:\ParsecTemp\Apps\directx_jun2010_redist.exe" -ArgumentList '/T:C:\ParsecTemp\DirectX /Q'-wait
		Start-Process -FilePath "C:\ParsecTemp\DirectX\DXSETUP.EXE" -ArgumentList '/silent' -wait
		ProgressWriter -Status "Installing Direct Play" -PercentComplete $PercentComplete
		Install-WindowsFeature Direct-Play | Out-Null
		ProgressWriter -Status "Installing .net 3.5" -PercentComplete $PercentComplete
		Install-WindowsFeature Net-Framework-Core | Out-Null
		ProgressWriter -Status "Cleaning up" -PercentComplete $PercentComplete
		Remove-Item -Path C:\ParsecTemp\DirectX -force -Recurse 
}






Function ExtractRazerAudio {
#Move extracts Razer Surround Files into correct location
	cmd.exe /c '"C:\Program Files\7-Zip\7z.exe" x C:\ParsecTemp\Apps\razer-surround-driver.exe -oC:\ParsecTemp\Apps\razer-surround-driver -y' | Out-Null
}

Function ModidifyManifest {
#modifys the installer manifest to run without interraction
	$InstallerManifest = 'C:\ParsecTemp\Apps\razer-surround-driver\$TEMP\RazerSurroundInstaller\InstallerManifest.xml'
		$regex = '(?<=<SilentMode>)[^<]*'
		(Get-Content $InstallerManifest) -replace $regex, 'true' | Set-Content $InstallerManifest -Encoding UTF8
}

#Audio Driver Install
function AudioInstall {
#(New-Object System.Net.WebClient).DownloadFile($(((Invoke-WebRequest -Uri https://www.tightvnc.com/download.php -UseBasicParsing).Links.OuterHTML -like "*Installer for Windows (64-bit)*").split('"')[1].split('"')[0]), "C:\ParsecTemp\Apps\tightvnc.msi")
	(New-Object System.Net.WebClient).DownloadFile("http://rzr.to/surround-pc-download", "C:\ParsecTemp\Apps\razer-surround-driver.exe")
#start-process msiexec.exe -ArgumentList '/i C:\ParsecTemp\Apps\TightVNC.msi /quiet /norestart ADDLOCAL=Server SET_USECONTROLAUTHENTICATION=1 VALUE_OF_USECONTROLAUTHENTICATION=1 SET_CONTROLPASSWORD=1 VALUE_OF_CONTROLPASSWORD=4ubg9sde SET_USEVNCAUTHENTICATION=1 VALUE_OF_USEVNCAUTHENTICATION=1 SET_PASSWORD=1 VALUE_OF_PASSWORD=4ubg9sde' -Wait
		ExtractRazerAudio
		ModidifyManifest
		$OriginalLocation = Get-Location
		Set-Location -Path 'C:\ParsecTemp\Apps\razer-surround-driver\$TEMP\RazerSurroundInstaller\'
		Start-Process RzUpdateManager.exe
		Set-Location $OriginalLocation
		Set-Service -Name audiosrv -StartupType Automatic
#Write-Output "VNC has been installed on this computer using Port 5900 and Password 4ubg9sde"
}

#Creates shortcut for the GPU Updater tool
function gpu-update-shortcut {
	(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/jamesstringerparsec/Cloud-GPU-Updater/master/GPUUpdaterTool.ps1", "$ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1")
		Unblock-File -Path "$ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1"
		ProgressWriter -Status "Creating GPU Updater icon on Desktop" -PercentComplete $PercentComplete
		$Shell = New-Object -ComObject ("WScript.Shell")
		$ShortCut = $Shell.CreateShortcut("$path\GPU Updater.lnk")
		$ShortCut.TargetPath="powershell.exe"
		$ShortCut.Arguments='-ExecutionPolicy Bypass -File "%homepath%\AppData\Roaming\ParsecLoader\GPUUpdaterTool.ps1"'
		$ShortCut.WorkingDirectory = "$env:USERPROFILE\AppData\Roaming\ParsecLoader";
	$ShortCut.IconLocation = "$env:USERPROFILE\AppData\Roaming\ParsecLoader\GPU-Update.ico, 0";
	$ShortCut.WindowStyle = 0;
	$ShortCut.Description = "GPU Updater shortcut";
	$ShortCut.Save()
}


