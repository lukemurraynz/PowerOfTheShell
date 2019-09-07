﻿#requires -Version 3.0 -Modules Az.Network
<#
      .SYNOPSIS
      Custom script to update your Azure Local Network Gateway with your Public IP
      .DESCRIPTION
      Updates the Azure Local Network Gateway with your Public IP
      Version: 1.0
      Author:  Luke Murray (Luke.Geek.NZ)
      If no Public IP parameter is set, it will automatically grab the Public IP of the computer running it and set it.
      The intention of this script is to run as as a scheduled task on your network, which connects to Azure and updates. Intended for Homelabs and scenarios which have Dynamic IPs.

  #>
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
  
$ErrorActionPreference = 'Stop'
Connect-AzAccount

[Object]$PublicIP = (Invoke-WebRequest -Uri 'http://ifconfig.me/ip').Content 
[string]$ResourceGroup = 'z_Network'
[string]$LocalNetworkGateway = 'Prod-SiteToSite-VLAN-LNGateway'
  
#-----------------------------------------------------------[Execution]------------------------------------------------------------  

 
  
$a = Get-AzLocalNetworkGateway -ResourceGroupName $ResourceGroup -Name $LocalNetworkGateway
$GatewayIP = $a.GatewayIpAddress
 

If ($PublicIP -ne $GatewayIP) {

    Write-Output -InputObject ('Updating the Local Network Gateway IP to {0}' -f $PublicIP)
    $a.GatewayIpAddress = $PublicIP
    Set-AzLocalNetworkGateway -LocalNetworkGateway $a

}
  
Else {

    Write-Output -InputObject 'Nothing needs to be done, the IP is already set'
    
}