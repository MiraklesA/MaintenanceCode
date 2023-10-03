<#Script for uninstalling Trend Anti-Virus from workstations.
Another basic script that removes Trend Micro, Software itself has a Regkey which stops any uninstalls however if you modify the reg key to 1, a silent uninstall will be allowed. 

#>
$Path = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion\Misc'
$RegName = 'Allow Uninstall'
$Value = '1'


Function Checker {
    $Version = Get-WmiObject -Class Win32_Product | Where-Object Name -eq "Trend Micro Security Agent"
    if ($Version.IdentifyingNumber -eq $null){
        Write-Host Trend Micro Not Detected
        exit
    }
    
    if ($Version.IdentifyingNumber){
        Return $Version.IdentifyingNumber
    }

    else {
        Write-Host Unexpected Error 
    }
}

$SoftwareID = Checker
New-ItemProperty -Path $Path -Name $RegName -Value $Value -PropertyType DWORD -Force 
Start-Process Msiexec.exe -ArgumentList "/X $SoftwareID /qn"
Write-Host Uninstallation Completed
