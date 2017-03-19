<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: To place an Operations Manager server group into maintenance mode for 120 minutes. 
    The $SCOMSERVER variable needs to change to point to your SCOM server and PowerShell Remoting (Enable-PSRemoting) needs to be enabled.
    The SCOMGroup Display name needs to also be changed to the group you want to place into maintenance mode.
    This needs to be run under a SCOM Administrator account.

#>

$SCOMServer = 'SCOMSERVER.DOMAIN.LOCAL'
enter-pssession -computername $SCOMServer -Credential (Get-Credential)
invoke-command -computername  $SCOMServer -scriptblock {

  Import-Module -Name OperationsManager
  $Instance = Get-SCOMGroup -displayname 'Patching Group 1' | Get-SCOMClassInstance
  $Time = ((Get-Date).AddMinutes(120))
  Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Reason 'PlannedOther' -Comment 'Server Patching'

}
Exit-Pssession