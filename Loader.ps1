cls
Write-Output "Setting up Environment"
$path = [Environment]::GetFolderPath("Desktop")
if((Test-Path -Path $path\ParsecTemp )-eq $true){} Else {New-Item -Path $path\ParsecTemp -ItemType directory | Out-Null}
Unblock-File -Path .\*
copy-Item .\* -Destination $path\ParsecTemp\ -Recurse | Out-Null
#lil nap
Start-Sleep -s 1
#Unblocking all script files
Write-Output "Unblocking files just in case"
Get-ChildItem -Path $path\ParsecTemp -Recurse | Unblock-File
Write-Output "Starting main script, this Window will close in 60 seconds"
start-process powershell.exe -verb RunAS -argument "-file $path\parsectemp\Scripts\PostInstall.ps1"
Start-Sleep -Seconds 60
