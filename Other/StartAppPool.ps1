#requires -Version 2.0
<#
    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Purpose: Basic script to start AppPool if stopped.
#>

$AppPoolName = AppPool

Import-Module -Name WebAdministration

if((Get-WebAppPoolState $AppPoolName).Value -ne 'Stopped')
{
  Start-WebAppPool -Name $AppPoolName
}
