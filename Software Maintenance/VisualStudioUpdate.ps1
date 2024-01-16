
# Creating the Scheduled Task - Basic Script that creates a schedueled task that auto updates visual studio
#-------------------------------------------------------------------------------------------------------

if (Get-ScheduledTask VSCodeITG -ea SilentlyContinue)
{
  Write-Host "Job Already Exists"
  exit
}

if (!(Get-ScheduledTask VSCodeEdit -ea SilentlyContinue)){

  $action = New-ScheduledTaskAction -Execute '"C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe"' `
  -Argument 'updateall --quiet'
  $trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 14 -At 10am
  $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun  -StartWhenAvailable 
  $principal = New-ScheduledTaskPrincipal -UserId 'nt authority\system' -RunLevel Highest
  $task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
  Register-ScheduledTask 'VSCodeEdit' -InputObject $task
  Write-Host "Job Completed"
  exit
}
#-------------------------------------------------------------------------------------------------------
