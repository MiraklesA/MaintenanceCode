if (Get-LocalUser -Name Administrator | Where-Object Enabled){
    Disable-LocalUser -Name "Administrator"
    if (Get-LocalUser -Name Administrator | Where-Object Enabled){
        Write-Host "Failed to disable the local user account."
    }
    if (!(Get-LocalUser -Name Administrator | Where-Object Enabled)) {
        Write-Host "Administrator has been disabled"

    }
    
}

if (!( Get-LocalUser -Name Administrator | Where-Object Enabled)) { 
    Write-Host "Administrator is not enabled"
}