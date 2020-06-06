# AWS EC2 Steam remote play Self Hosted Cloud Setup Script

This script sets up your cloud computer with a bunch of settings and drivers
to make your life easier.  
                    
It's provided with no warranty, so use it at your own risk.

Then fill in the details on the next page.


### Instructions:                    
1. Set up your GPU accelerated cloud machine on AWS. 
2. Log in via RDP and make note of the password - you'll need it later
3. Open Powershell on the cloud machine.
4. Copy the below code and follow the instructions in the script - you'll see them in RED

```
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"  
(New-Object System.Net.WebClient).DownloadFile("https://github.com/neutrinus/EC2SteamRemotePlay/archive/master.zip","$ENV:UserProfile\Downloads\EC2SteamRemotePlay.zip")  
New-Item -Path $ENV:UserProfile\Downloads\EC2SteamRemotePlay -ItemType Directory  
Expand-Archive $ENV:UserProfile\Downloads\EC2SteamRemotePlay.Zip -DestinationPath $ENV:UserProfile\Downloads\EC2SteamRemotePlay
CD $ENV:UserProfile\Downloads\EC2SteamRemotePlay\EC2SteamRemotePlay-master\  
Powershell.exe -File $ENV:UserProfile\Downloads\EC2SteamRemotePlay\EC2SteamRemotePlay-master\Loader.ps1
```

This tool supports:

### OS:
Server 2016  
Server 2019
                    
### CLOUD SKU:
AWS G3S.xLarge    (Tesla M60)  

Q. Stuck at 24%  
A. Keep waiting, this installation takes a while.

Q. My cloud machine is stuck at 1366x768  
A. Make sure you use GPU Update Tool to install the driver, and on Google Cloud you need to select the Virtual Workstation option when selecting an NVIDIA GPU when setting up an instance.

Q. My Xbox 360 Controller isn't detected in Windows Server 2019  
A. You will need to visit Device Manager, and choose to Automatically Update "Virtual Xbox 360 Controller" listed under the Unknown Devices catagory in Device Manager.

Q. I made a mistake when adding my AWS access key or I want to remove it on my G4DN Instance  
A. Open Powershell and type `Remove-AWSCredentialProfile -ProfileName GPUUpdateG4Dn` - This will remove the profile from the machine.

Q. What about GPU X or Cloud Server Y - when will they be supported?  
A. That's on you to test the script and describe the errors you see, do not create an issue in Github that does not contain an issue.  Do not create an issue without any actual diagnosis information or error messages.



