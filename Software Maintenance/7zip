$URL = "https://www.7-zip.org/a/7z2301-x64.msi"
$Installdir = "C:\temp\7zip.msi"

function uninstall {
    if (test-path "C:\Program Files\7-Zip\Uninstall.exe") {
        start-process -File "C:\Program Files\7-Zip\Uninstall.exe" -ArgumentList "/S"
        install
    }

    if ($7Zip.IdentifyingNumber) { 
        start-process msiexec.exe -ArgumentList "/x $7Zip.IdentifyingNumber /qn"
        install
    }

    if (!(test-path "C:\Program Files\7-Zip\Uninstall.exe")){
        install
    }

    else { 
        Write-host "Unkown Error"
    }
}

function install { 
    Invoke-WebRequest -Uri $URL -OutFile $Installdir
    start-process msiexec.exe -ArgumentList "/i $Installdir /qn" -Wait

    Write-Host "7-Zip Succesfully installed"

    if (Test-Path $Installdir){
        remove-item $Installdir -Force
    }
    exit
}

try {
    $7Zip = Get-WmiObject -Class Win32_Product | Where-Object Name -Like "7*"
    if ($7Zip.version -like '23*') {
        Write-Host "7-Zip is already up to date*"
        exit
    }

    if (!($7Zip.version)) {
        uninstall

    }

    if ($7Zip.version -notlike '23*') {
        uninstall

    }


    else {
        write-host unkown error 
        exit
    }
}


catch { 
    exit

}


