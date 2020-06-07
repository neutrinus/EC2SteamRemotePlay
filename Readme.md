# AWS EC2 Steam remote play Self Hosted Cloud Setup Script

This script sets up your cloud computer with a bunch of settings and drivers
to make your life easier. 
 
Based on:
* https://medium.com/@bmatcuk/gaming-on-amazon-s-ec2-83b178f47a34
* https://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html
* https://github.com/jamesstringerparsec/Parsec-Cloud-Preparation-Tool
* https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html

Thanks for the fishes!


### Instructions:                    
0. Configure `awc-cli` with your credentials
1. Create Spot instance on AWS EC2: `./create_aws_ec2_spot_req.sh`
2. Log in via RDP and make note of the password - you'll need it later
3. Open Powershell on the cloud machine.
4. Copy the below code and follow the instructions in the script:

```
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"  
(New-Object System.Net.WebClient).DownloadFile("https://github.com/neutrinus/EC2SteamRemotePlay/archive/master.zip","$ENV:UserProfile\Downloads\EC2SteamRemotePlay.zip")  
New-Item -Path $ENV:UserProfile\Downloads\EC2SteamRemotePlay -ItemType Directory  
Expand-Archive $ENV:UserProfile\Downloads\EC2SteamRemotePlay.Zip -DestinationPath $ENV:UserProfile\Downloads\EC2SteamRemotePlay
CD $ENV:UserProfile\Downloads\EC2SteamRemotePlay\EC2SteamRemotePlay-master\  
Powershell.exe -File $ENV:UserProfile\Downloads\EC2SteamRemotePlay\EC2SteamRemotePlay-master\run.ps1
```

6. Run Steam client, login 


