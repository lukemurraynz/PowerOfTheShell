#Runs from SCOM agent on server (requires SCOM 2016)

$duration = '10'
$reason = 'ApplicationInstallation'
$comment = 'Comment'

Import-module “C:\Program Files\Microsoft Monitoring Agent\Agent\MaintenanceMode.dll”
Start-SCOMAgentMaintenanceMode -Duration $duration -Reason $reason -Comment “Test”

<#

The following reasons are accepted by the cmdlet:

Requires SCOM 2016

    PlannedOther
    UnplannedOther
    PlannedHardwareMaintenance
    UnplannedHardwareMaintenance
    PlannedHardwareInstallation
    UnplannedHardwareInstallation
    PlannedOperatingSystemReconfiguration
    UnplannedOperatingSystemReconfiguration
    PlannedApplicationMaintenance
    UnplannedApplicationMaintenance
    ApplicationInstallation
    ApplicationUnresponsive
    ApplicationUnstable
    SecurityIssue
    LossOfNetworkConnectivity

#>


#Function below checks what the maint mode settings are from the registry key:
function Get-SCOMAgentMaintenanceMode {
$mm=(Get-ItemProperty “hklm:\software\microsoft\microsoft operations manager\3.0\maintenancemode”).Record
$split=$mm.split(“|”)
write-host “Duration:”$split[0]”
Reason:”$split[1]”
User:”$split[2].split(“:”)[0]”
Comment:”$split[2].split(“:”)[1]”
StartTime:”$split[3]
}
Get-SCOMAgentMaintenanceMode
