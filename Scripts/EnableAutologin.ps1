
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

Function Set-AutoLogon {
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

