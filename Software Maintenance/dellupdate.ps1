$PathA = "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
$PathB = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
$a = 9
$b = 0
$ConfirmationA = Test-Path $PathA
$ConfirmationB = Test-Path $PathB
Function Execute ($FilePath){
    $DellUpdate = Get-WmiObject -Class Win32_Product | Where-Object Name -Like "Dell Command*"
    $DellUpdateV = $DellUpdate.Version
    if ([System.Version]"$DellUpdateV" -lt [System.Version]"3.1.0"){
        do {
        Start-Process -Wait -FilePath "$FilePath" -ArgumentList "/silent"
        Start-Sleep -S 150
        $DellConfirmation = Get-WmiObject -Class Win32_Product | Where-Object Name -Like "Dell Command*"
        $DellConfirmationV = $DellConfirmation.Version
        $b++

        if ($b -ge 5){ 
            Write-Host "Script Timed Out Update Unsuccesfull"
        }
        }

        until ([System.Version]"$DellConfirmationV" -ge [System.Version]"3.1.0")

        Write-Host "Dell Command Update has been updated from $DellConfirmationV"
    }

    Start-Process -Wait -FilePath "$FilePath" -ArgumentList "/applyUpdates -outputLog=C:\Temp\DellCommand.log"
    do {
        Start-Sleep -S 150
        $DellUpdate = Get-WmiObject -Class Win32_Product | Where-Object Name -Like "Dell Command*"
        $DellVersion = $DellUpdate.version
        if ([System.Version]"$DellVersion" -ge [System.Version]"5.1.0") { 


            Write-Host "Dell Command Update has executed and has updated to $DellVersion"
            Get-Content -Path "C:\Temp\DellCommand.log"
            Remove-Item "C:\Temp\DellCommand.log"
            exit
        }
    $a--
    }
    until ($a -le 3)

    Write-Host "Dell Command Update has failed"
    Get-Content -Path "C:\Temp\DellCommand.log"
    Remove-Item "C:\Temp\DellCommand.log"
    exit
 }
 
Switch ($True) {
    $ConfirmationA {Execute ($PathA)}
    $ConfirmationB {Execute ($PathB)}
}


<# 

Steps: 


A: Detect which file path is correct
B: Check for Dell Command Update Version
C: Run .exe with /applyupdates or if Dell Update is Pre Version3 .1 Run with /Silent 
D: Write a log to C:\Temp which gets printed to the output and deleted
E: Idle for 5 minutes to ensure update has been completed.
F: Write-host JOB is done


Sample MSI Output: 

Dell Command Update Universal
IdentifyingNumber : {612F7720-D28A-473F-8FB9-C8D300B5F534}                                                                                                                                                                                  
Name              : Dell Command | Update for Windows Universal                                                                                                                                                                             
Vendor            : Dell Inc.                                                                                                                                                                                                               
Version           : 5.1.0                                                                                                                                                                                                                   
Caption           : Dell Command | Update for Windows Universal


#>