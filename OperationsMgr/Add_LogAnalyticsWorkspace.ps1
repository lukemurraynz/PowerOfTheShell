<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: Add an MMA agent to a Log Analytics workspace using a proxy with no user authentication.
    Notes:
    Find more options about the MMA Agent Object:
    #$healthServiceSettings = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    #$proxyMethod = $healthServiceSettings | Get-Member -Name 'SetProxyInfo'

    If script is being published by Configuration as a package, create a Command Line installer:
    "%Windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -Command  .\Add_LogAnalyticsWorkspace.ps1

    If the proxy requires authentication, then the following null entries need to be replaced with user,password: $mma.SetProxyInfo("$proxy","$null","$null"). If you aren't using a proxy then you can remove the entire mma.SetProxyInfo line.

    Location: https://github.com/lukemurraynz/PowerOfTheShell/blob/master/OperationsMgr/Add_LogAnalyticsWorkspace.ps1
#>

$workspaceId = "INSERTLOGANALYTICSWORKSPACEIDHERE"
$workspaceKey = "INSERTLOGANALYTICSWORKSPACEKEY"
$proxy = 'ProxyIP:PORT'
$mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
$mma.AddCloudWorkspace($workspaceId, $workspaceKey)
$mma.SetProxyInfo("$proxy","$null","$null")
$mma.ReloadConfiguration()