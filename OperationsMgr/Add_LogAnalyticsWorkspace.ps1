<#

    Author: Luke Murray (Luke.Geek.NZ)
    Version: 0.1
    Version History:

    Purpose: Add an MMA agent to a Log Analytics workspace using a proxy with no user authentication.
    Notes:
    Find more options about the MMA Agent Object:
    #$healthServiceSettings = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    #$proxyMethod = $healthServiceSettings | Get-Member -Name 'SetProxyInfo'

    If script is being published by SCCM as a package, create a Command Line installer:
    "%Windir%\sysnative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -Command  .\Add_LogAnalyticsWorkspace.ps1

#>

$workspaceId = "INSERTLOGANALYTICSWORKSPACEIDHERE"
$workspaceKey = "INSERTLOGANALYTICSWORKSPACEKEY"
$proxy = 'ProxyIP:PORT'
$mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
$mma.AddCloudWorkspace($workspaceId, $workspaceKey)
$mma.SetProxyInfo("$proxy","$null","$null")
$mma.ReloadConfiguration()