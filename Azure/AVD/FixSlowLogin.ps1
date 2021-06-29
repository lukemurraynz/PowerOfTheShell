#Removes a bunch of registry keys, that causes issues with slow login and Start Menu not showing. The server needs to be restarted once this keys have been removed.
Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\Configurable\System"
New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\Configurable\System"
Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"
New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"
Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications" -Recurse
New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications"