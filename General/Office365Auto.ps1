<# 
Checks if the below registry exists: 
HKLM\SOFTWARE\policies\Microsoft\office\16.0\common\officeupdate\enableautomaticupdates
If it doesn't it will add it and set the value to 1. 

#>

$Path = 'HKLM:\SOFTWARE\policies\Microsoft\office\16.0\common\officeupdate'
$Exists = Test-Path $Path


if ($Exists){
    if ((Get-ItemProperty -Path $Path -Name 'enableautomaticupdates').enableautomaticupdates -eq $true) {
        Write-Host "Registry Key already exists."
    }
    else { 
        New-ItemProperty -LiteralPath $Path -Name 'enableautomaticupdates' -value 1 -PropertyType DWord -force -ea SilentlyContinue | Out-Null
        Write-Host "Registry Key has been added"
    }
}

if (!($Exists)){
    New-Item -Path $Path -Force | Out-Null
    New-ItemProperty -LiteralPath $Path -Name 'enableautomaticupdates' -value 1 -PropertyType DWord -force -ea SilentlyContinue | Out-Null
    Write-Host "Registry Key has been added"
}


