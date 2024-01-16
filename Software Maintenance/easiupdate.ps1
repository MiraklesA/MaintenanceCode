$Path = "C:\ProgramData\Seewo\Easiupdate\Uninstall.exe"

if (!(Test-Path $Path)){
    Write-Host "Easiupdate is not installed"
}



If (Test-Path $Path){
    Start-Process -Wait -FilePath "$Path" -ArgumentList "/S"
    if (Test-Path $Path){
        Write-Host "The uninstallation was successful."
        exit
    }
    Write-Host "Easiupdate has been uninstalled"
    Remove-Item -Path C:\ProgramData\Seewo -Force
}




