#Simple script to enable OneDrive Sync Report, registry entry needs to be set on endpoint devices with the Tenant ID.
# https://docs.microsoft.com/en-us/onedrive/sync-health
$tenantid = '1234567890'
New-Item -Path 'HKLM:\Software\Policies\Microsoft\OneDrive' -Force
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\OneDrive' -Name 'SyncAdminReports' -Value "$tenantid" -PropertyType String -Force 