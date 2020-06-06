
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
		(New-Object System.Net.WebClient).DownloadFile("https://s3.amazonaws.com/parsec-files-ami-setup/Devcon/devcon.exe", "C:\ParsecTemp\Devcon\devcon.exe")
		(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/jamesstringerparsec/Cloud-GPU-Updater/master/GPUUpdaterTool.ps1", "$env:APPDATA\ParsecLoader\GPUUpdaterTool.ps1")
		(New-Object System.Net.WebClient).DownloadFile("https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi", "C:\ParsecTemp\Apps\googlechromestandaloneenterprise64.msi")


		start-process -filepath "C:\Windows\System32\msiexec.exe" -ArgumentList '/qn /i "C:\ParsecTemp\Apps\googlechromestandaloneenterprise64.msi"' -Wait
		Start-Process -FilePath "C:\ParsecTemp\Apps\directx_jun2010_redist.exe" -ArgumentList '/T:C:\ParsecTemp\DirectX /Q'-wait
		Start-Process -FilePath "C:\ParsecTemp\DirectX\DXSETUP.EXE" -ArgumentList '/silent' -wait
		Install-WindowsFeature Direct-Play | Out-Null
		Install-WindowsFeature Net-Framework-Core | Out-Null
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


