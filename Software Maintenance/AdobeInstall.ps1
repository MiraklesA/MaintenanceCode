
<# Only Execute script if User is aware: 

The Script Forcefully closes Adobe and updates it to the package detected on the Software Share, 
As Adobe does not have different identifying numbers between Adobe Reader and Adobe Pro

Only run on devices that require Adobe Reader to be converted to Adobe Pro.
#>


Function Install { 
    $SourceFile = "$Extracteddir\Adobe Acrobat\setup.exe"
    $Check = Test-Path $SourceFile
    Switch ($Check){ 
        $True {
            start-process -FilePath "$SourceFile" -Wait -ArgumentList "/S"
            Start-Sleep -Seconds 300
        }
        $False {
            Write-Host "Path is unavailable exiting script"
            exit 
        }
    }
    $AdobeComp = Get-WMIObject -Class Win32_Product | Where-Object Name -Like ("Adobe Acro*")
    if ($AdobeComp) {
        Write-Host "Adobe Pro Sucesfully Installed"
        Remove-Item $Extracteddir -Force -Recurse
        Remove-Item $Installdir -Force -Recurse
    }
    
}

Function Stager { 
    $DownloadFile = Test-Path "C:\Temp\Adobe.zip"
    $InstallFile = Test-Path "C:\Temp\AdobeExtracted"
 
    if ($DownloadFile -eq $True){ 
        if (!($InstallFile)){
           Expand-Archive -Path $Installdir -DestinationPath $Extracteddir -Force
           install 
        }

        if ($InstallFile -eq $True){
            Remove-Item $Extracteddir -Force -Recurse
            Expand-Archive -Path $Installdir -DestinationPath $Extracteddir -Force
            install 
        }
    }

    if ($DownloadFile -eq $False){
        Return
    }
}


 
$URL = "https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/win32/Acrobat_DC_Web_x64_WWMUI.zip"
$Installdir = "C:\Temp\Adobe.zip"
$Extracteddir = "C:\Temp\AdobeExtracted"

Stop-Process
Stager

Invoke-WebRequest -Uri $URL -OutFile $Installdir
Expand-Archive -Path $Installdir -DestinationPath $Extracteddir -Force


$Adobe = Get-WMIObject -Class Win32_Product | Where-Object Name -Like ("Adobe Acro*")
$AdobeID = ($Adobe).IdentifyingNumber
if ($null -eq $Adobe) {
    Install
}

else {
    $x = 1 
    do {
        foreach ($AdobeID in $AdobeID) {
            start-process msiexec.exe -ArgumentList "/x $AdobeID /qn" -Wait
            Start-Sleep -Seconds 150
        }
        $AdobeCheck = Get-WMIObject -Class Win32_Product | Where-Object Name -Like ("Adobe Acro*")
        $x++ 

        if ($x=6){
            Write-Host "Adobe Uninstallation unsuccesfull"
        }
    } until($null -eq $AdobeCheck)
    install 

}
