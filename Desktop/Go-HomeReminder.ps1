#requires -Modules BurntToast

<#
    .SYNOPSIS
    Go-HomeReminder

    .DESCRIPTION
    Quick script intended to be setup as a Scheduled Task to run hourly to notify me to actually leave work!
    Requires the BurntToast module (https://github.com/Windos/BurntToast)

    .NOTES
    Version:        0.1
    Author:         Luke Murray (Luke.Geek.NZ)
    Creation Date:  13/06/18
    Purpose/Change: 
    13/06/18 - Intiial script development
  
#>

$os = Get-WmiObject win32_operatingsystem
$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
$round = [math]::Round($uptime.hours)

If ($uptime.Hours -gt '8') {

    New-BurntToastNotification -Text "Go Home - your computer has been on for $round Hours"

}
else {
    
    New-BurntToastNotification -Text "Your computer has been on for $round hours" -SnoozeAndDismiss
}