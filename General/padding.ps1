<# 
The script adds the enableAuthenticodeVerification64 key to the below
 
Windows Registry Editor Version 5.00: 

[HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Wintrust\Config]  
"EnableCertPaddingCheck"="1"

 
[HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config]
"EnableCertPaddingCheck"="1"

#>

function checkcreate {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullorEmpty()]
        [string] $Path
    )

    if ((Get-ItemProperty -Path $Path -Name 'EnableCertPaddingCheck').EnableCertPaddingCheck -eq 1) {
        Write-Host "Registry Key already exists at $Path."
    }
    else { 
        New-ItemProperty -LiteralPath $Path -Name 'EnableCertPaddingCheck' -value 1 -PropertyType string -force -ea SilentlyContinue | Out-Null
        Write-Host "Registry Key has been added at $Path"
    }
}

function create {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullorEmpty()]
        [string] $Path
    )

    New-Item -Path $Path -Force | Out-Null
    New-ItemProperty -LiteralPath $Path -Name 'EnableCertPaddingCheck' -value 1 -PropertyType string -force -ea SilentlyContinue | Out-Null
    Write-Host "Registry Key has been added at $Path"
}

$Path1 = Test-Path 'HKLM:\Software\Microsoft\Cryptography\Wintrust\Config'
$Path2 = Test-Path 'HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config'

Switch ($True)
{
    $Path1 {checkcreate 'HKLM:\Software\Microsoft\Cryptography\Wintrust\Config'}
    $Path2 {checkcreate 'HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config'}
} 

Switch ($False)
{
    $Path1 {create 'HKLM:\Software\Microsoft\Cryptography\Wintrust\Config'}
    $Path2 {create 'HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config'}
}


