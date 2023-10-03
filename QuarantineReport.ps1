#Get-QuarantineMessage -StartReceivedDate 03/01/2023 -EndReceivedDate 04/03/2023|Select ReceivedTime,SenderAddress,RecipientAddress,Subject,MessageID,RecipientCount,QuarantineTypes| Export-Csv -Path "D:\QuarantinedEmailsbyDateRange.csv" -NoTypeInformation -Append �Force
<#
.DESCRIPTION:
Script focuses on authenticating you via exchange online to automatically extract a CSV sheet of the last 7 days of qurantine logs. Useful for reporting. 
#> 
[CmdletBinding(DefaultParameterSetName='Default')]
Param ( 
    [parameter(Mandatory=$false, ParameterSetName = "Log")]
    [Alias("l" , "log")]
    [Switch]$DataLogCheck, 

    [parameter(Mandatory=$false, ParameterSetName = "Help")]
    [Alias("h")]
    [Switch]$Help 
)

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

$ErrorActionPreference = "SilentlyContinue"

Function Cleanup {
    if (!($DataLogCheck)){
        Remove-Item "C:\Temp\Log.txt" -Force
    }
}

if($Help){
    Write-Host "This script generates a qurantine list and save sit to C:\Temp"

}

try {
    Function ExchangeOnline{ 
        process { 
            if (!(Get-Module -ListAvailable -Name ExchangeOnlineManagement))
            {
                Write-Host "Exchange Online Management is not installed on this device would you like to install it?" -ForegroundColor Yellow
                $install = Read-Host Would you like to install this module? [Y] [N]
                if ($install -match "[yY]")
                {
                    Install-Module -Name ExchangeOnlineMangement -AllowClobber -Force
                    Write-Host "Installing Now" -ForegroundColor Green
                 }
                else {
                    Write-Error "Unable To Proceed"
                }
            }
    
    
            if ((Get-Module -ListAvailable -Name ExchangeOnlineManagement))
            {
                $psSessions = Get-PSSession | Select-Object -Property State, Name
                If (((@($psSessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*, ').Count -gt 0) -ne $true) {
                    Connect-ExchangeOnline
                    return
            }
            else { 
                Write-Error "Unable to Proceed"
            }
    
        }
        }
    
    }
    
    
    $Today = Get-Date -Format MM/dd/yyyy
    $LastDate = Get-Date (Get-Date).AddDays(-7) -Format MM/dd/yyyy

    ExchangeOnline
    Get-QuarantineMessage -StartReceivedDate $LastDate -EndReceivedDate $Today|Select ReceivedTime,SenderAddress,RecipientAddress,Subject,RecipientCount,QuarantineTypes| Export-Csv -Path "C:\Temp\QuarantinedEmailsbyDateRange.csv" -NoTypeInformation -Force
    Disconnect-ExchangeOnline -Force
    exit
}

Catch {
    Logger "$Error" "C:\Temp\Log.txt"
}
