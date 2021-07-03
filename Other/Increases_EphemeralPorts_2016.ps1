<#
    .SYNOPSIS
    Increase Pool Size for Ephemeral TCP Ports

    .DESCRIPTION
    This script was created increasing the pool Size for Ephemeral TCP Ports and setting the WaitTimeDelay so that the operating system and applications can reuse the ports.
    .NOTES
    Version:        1.0
    Author:         Luke Murray (luke.geek.nz)
    Purpose/Change:
    Initial script creation - created as a workaround for an issue, with ports not getting released successfully.

    .EXAMPLE
    ./Increases_EphemeralPorts_2016.ps1
   
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Get-Item 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-ItemProperty -Name MaxUserPort -Value 65534 -Force | Out-Null
Get-Item 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-ItemProperty -Name TcpTimedWaitDelay -Value 30 -Force | Out-Null
Get-Item 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-ItemProperty -Name TcpNumConnections -Value 16777214 -Force | Out-Null
Get-Item 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' | New-ItemProperty -Name TcpMaxDataRetransmissions -Value 5 -Force | Out-Null
Restart-Computer -Force