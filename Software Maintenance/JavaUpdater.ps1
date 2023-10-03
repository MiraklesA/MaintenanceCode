<# 
Get-WmiObject -Class Win32_Product | Where-Object Name -Like "Java*"
IdentifyingNumber : {D2D0311F-1C55-57CC-95CC-F973FA7660D4}
Name              : Java(TM) SE Development Kit 20.0.2 (64-bit)
Vendor            : Oracle Corporation
Version           : 20.0.2.0
Caption           : Java(TM) SE Development Kit 20.0.2 (64-bit)



    503      29   388648     152280       1.11   1572   1 java
    127       9     1492       7792       0.02   8232   1 java <------------- Process Name
#>


<# .DESCRIPTION: Powershell script that downloads a JDK version in this instance Java 21 and uninstalls any other unspecified versions of Java.
To Modify for future versions of JDK, we will need to modify the initial EXE name alongside changing the VersionCheck function.
#> 

[CmdletBinding(DefaultParameterSetName='Default')]
Param ( 
    [parameter(Mandatory=$false, ParameterSetName = "Log")]
    [Alias("l" , "log")]
    [Switch]$DataLogCheck,

    [parameter(Mandatory=$false, ParameterSetName = "ForceInstance")]
    [Alias("f")]
    [Switch]$Force
)

$ErrorActionPreference = "SilentlyContinue"
$Installdir = "C:\Temp\jdk-21.exe"


Function ForceCheck {
    if (!($Force)) {
        if($null -eq (Get-Process "Java" -ea SilentlyContinue)) {
            Write-Output "Java Instance Is Not Running" >> C:\Temp\Log.txt
        }
        else {
            Write-Output "Java Instance Is Currently Running Exiting Script" >> C:\Temp\Log.txt
            Write-Host "Java Instance Is Currently Running Exiting Script" 
            Cleanup
            exit
        }
    }

    if ($Force){ 
        Stop-Process -Name "Java"
    }
}

Function Cleanup {
    if (!($DataLogCheck)){
        Remove-Item "C:\Temp\Log.txt" -Force
    }
}

Function Logger {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullorEmpty()]
        [string] $Message,

        [Parameter(Mandatory=$true, Position=1)]
        [string] $LogPath
    )


    process {
        Try { 
            Add-Content -Path $LogPath -Value $Message
            Cleanup
        }
        Catch {
            Write-Host "Error:" $_.Exception.Message
            Cleanup
        }
    }
}

Try { 
    Function VersionCheck { 
        $JavaDet = Get-WmiObject -Class Win32_Product | Where-Object Name -Like "Java*"
        $JavaVer = ($JavaDet).version
        $JavaID = ($JavaDet).IdentifyingNumber
        if ("$JavaVer" -like '21*') {
            Write-Output "$env:COMPUTERNAME has the correct version of java installed." >> C:\Temp\Log.txt
            Write-Host "Java $JavaVer is already installed on $env:COMPUTERNAME"
            Cleanup
            exit
        }
        ForceCheck
        Invoke-WebRequest -Uri "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe" -OutFile $Installdir
        
    
        if (!(Test-Path "$Installdir")) { 
            Write-Host "Unable to access installation directory"
            exit
        }
    
        if (!("$JavaVer" -like '21*')) { 
            Write-Output "$env:COMPUTERNAME does not have Java 21 installed!" >> C:\Temp\Log.txt
            return $JavaID

        }

        else { 
            Write-Error "Unkown Error Flag 1"
        }
    }

    $JavaID = VersionCheck
    
    if ($JavaID) { 
        foreach ($JavaID in $JavaID) {
            Start-Process msiexec.exe -Wait -ArgumentList "/x $JavaID /qn"
            Start-Process -Wait -FIlePath "$Installdir" -ArgumentList "/s" 
            Write-Output "Java 21 has been installed on $env:COMPUTERNAME" >> C:\Temp\Log.txt
            Write-Host "Java 21 has been installed on $env:COMPUTERNAME"
        }

    }
    
    if (!($JavaID)) { 
        Start-Process -Wait -FilePath "$Installdir" -ArgumentList "/s" 
        Write-Output "Java 21 has been installed on $env:COMPUTERNAME" >> C:\Temp\Log.txt
        Write-Host "Java 21 has been installed on $env:COMPUTERNAME"
        
    }

    Remove-Item -Path $Installdir -Force 
    Cleanup
}

Catch { 
    Logger "$Error" "C:\Temp\Log.txt"
}
