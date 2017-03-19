<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: Simple 1 liner to create a new Windows Event Log and Source. These sources can then be written to by PowerShell scripts or Applications.
    Change the $log - CompanyName variable to be the name of the Event Log name you want to create.

#>

$log = CompanyName
New-Eventlog -source "$log" -logname $log
New-Eventlog -source 'Patching' -logname $log
New-Eventlog -source 'Monitoring' -logname $log