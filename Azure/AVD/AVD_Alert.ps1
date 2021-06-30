#https://raw.githubusercontent.com/tsrob50/WVD-Public/master/WVDARM_ScaleHostPoolVMs.ps1 
#AVD Alert for user session limit
# Set default error action
$defaultErrorAction = $ErrorActionPreference

# Enable Verbose logging  
$VerbosePreference = 'SilentlyContinue'

$hostPoolName = 'avd-pooled'
$hostPoolRg = 'avd_prod'

$hostPool = Get-AzWvdHostPool -ResourceGroupName $hostPoolRg -HostPoolName $hostPoolName 
    $sessionHosts = Get-AzWvdSessionHost -ResourceGroupName $hostPoolRg -HostPoolName $hostPoolName | Where-Object { $_.AllowNewSession -eq $true }
    $runningSessionHosts = $sessionHosts | Where-Object { $_.Status -eq "Available" }
# Get the Max Session Limit on the host pool
# This is the total number of sessions per session host
$maxSession = $hostPool.MaxSessionLimit
# Get current active user sessions
$currentSessions = 0
foreach ($sessionHost in $sessionHosts) {
    $count = $sessionHost.session
    $currentSessions += $count
}
$runningSessionHostsCount = $runningSessionHosts.count
$sessionHostTarget = [math]::Ceiling((($currentSessions) / $maxSession))
if ($runningSessionHostsCount -lt $sessionHostTarget) {
    Write-Verbose "Running session host count $runningSessionHostsCount is less than session host target count $sessionHostTarget"

}
elseif ($runningSessionHostsCount -gt $sessionHostTarget) {
    Write-Verbose "Running session hosts count $runningSessionHostsCount is greater than session host target count $sessionHostTarget"

}
else {
    Write-Verbose "Running session host count $runningSessionHostsCount matches session host target count $sessionHostTarget, doing nothing"
}