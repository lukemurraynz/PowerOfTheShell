 <#
      .SYNOPSIS
      Sets some TCP and Windows 10 network/TCP optimization settings.
      .DESCRIPTION
      Sets some TCP and Windows 10 network/TCP optimization settings. The intention is for the script to make some quick registry changes that could help with network performance.
      Please note, I take no responsibility for the impact of this script and make sure you have a registry backup before running it.
      .AUTHOR: Luke Murray (Luke.Geek.NZ)
      .VERSION: 0.1
  #>


#Turns off Windows Update Peering (Allow Downloads from other PCs)
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -Value '0'

#Uninstall OneNote AppX Package
Get-AppxPackage *OneNote* | Remove-AppxPackage

#Disable Window Auto-Tuning
netsh int tcp set global autotuninglevel=disabled 

#Disables Large Send Offload V2 (IPv4 + IPv6)

$adapters = Get-NetAdapter
ForEach ($adapter in $adapters)
{
    Disable-NetAdapterChecksumOffload -Name $adapter.Name

}

#Limits Reversible bandwith - Stops Windows from reserving 20% of bandwidth for OS tasks

Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\Psched -Name NonBestEffortLimit -Value '0'
