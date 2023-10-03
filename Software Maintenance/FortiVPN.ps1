<# Extremely Basic script that updates the FortiVPN to the latest version 7.09. 
The script is quite basic and still uses heavy static variables will be optimised in the future to include an online installer/log function / less static variables. 
PLEASE note the script forces a computer to restart
#>

$ErrorActionPreference = 'SilentlyContinue'
$secondpath = "" #Secondary Path IE local Temp
$path = "" #Primary Path IE Dedicated File Share
$DesiredVersion = "7.09.0493"



Function Main { 
    process { 
        if((Get-Process "Forticlient" -ea SilentlyContinue) -eq $null) {
            if (Test-Path -Path $secondpath) {
                Write-Host "Local Path Chosen"
                VPNInstall($secondpath)
            }
    
            if (Test-Path -Path $path) {
                Write-Host "Network Path Chosen"
                VPNInstall($path)
            }
    
            else {
                Write-Host "No Valid Path Detected"
                exit
            }
    
        }
        
        else {
            Write-Host "FortiVPN is running unable to continue the script"
            exit
        }



    }

}


function VPNInstall($installpath) {
    process { 
        $VPNVers = Get-WmiObject Win32_Product | Where-Object Name -eq "FortiClient VPN"

        if ($VPNVers.version -contains $DesiredVersion) {
            Write-Host "VPN is already version $DesiredVersion"
            exit
        }

        else {

            msiexec /i "$installpath" /quiet /qn /norestart
            Write-Host "Installation Completed"
            Start-Sleep -Seconds 90
            Start-Sleep -Seconds 30 | Restart-Computer -Force
            exit

        }
    }
}

Main 

