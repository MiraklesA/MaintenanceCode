<#
Script that autoupdates Adobe Pro/Reader & Creative Cloud Products
You require a copy of the Adobe Remote Update Manager in order to automatically update files, this script creates a schedueled task that forces this process and saves it under ProgramData
#>


$DownloadURL = "" #<----------- Insert download URL for Adobe RUM https://helpx.adobe.com/au/enterprise/using/using-remote-update-manager.html
$Installdir = "C:\ProgramData\Adobe\RemoteUpdateManager"


$path = "$Installdir"
If(!(test-path "$path\RemoteUpdateManager.exe"))
{
      New-Item -ItemType Directory -Path $path
      Invoke-WebRequest -Uri $DownloadURL -OutFile "$Installdir\RemoteUpdateManager.exe"
}


# Creating the Scheduled Task 
#-------------------------------------------------------------------------------------------------------

if (Get-ScheduledTask AdobeUserUPDT -ea SilentlyContinue)
{
  Write-Host "Job Already Exists"
}

if (!(Get-ScheduledTask AdobeUserUPDT -ea SilentlyContinue)){

  $action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
  -Argument 'C:\ProgramData\Adobe\RemoteUpdateManager\RemoteUpdateManager.exe | Out-File C:\ProgramData\Adobe\RemoteUpdateManager\Log.txt'
  $trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 14 -At 10am
  $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
  $principal = New-ScheduledTaskPrincipal -UserId 'nt authority\system' -RunLevel Highest
  $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
  Register-ScheduledTask 'AdobeUserUPDT' -InputObject $task
  Write-Host "Job Completed"
}



#-------------------------------------------------------------------------------------------------------



