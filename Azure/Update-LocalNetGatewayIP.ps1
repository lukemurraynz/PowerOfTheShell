#requires -Version 3.0 -Modules Az.Network
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

[Object]$PublicIP = (Invoke-WebRequest -Uri 'http://ifconfig.me/ip').Content 
[string]$ResourceGroup = 'z_Network'
[string]$LocalNetworkGateway = 'Prod-SiteToSite-VLAN-LNGateway'

# Use the application ID as the username, and the secret as password
$azureAplicationId ="Azure AD Application Id"
$azureTenantId= "Your Tenant Id"
$azureAPI = "Your API Key"
$azurePassword = ConvertTo-SecureString "$azureAPI" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAplicationId , $azurePassword)
Connect-AzAccount -Credential $psCred -TenantId $azureTenantId  -ServicePrincipal 

<#

Before adding the Azure Service Principal in and testing as a Scheduled Task, it is recommended that you just test the script first by connecting manually using:

Connect-AzAccount

 #>
  
#-----------------------------------------------------------[Execution]------------------------------------------------------------  

 
  
$a = Get-AzLocalNetworkGateway -ResourceGroupName $ResourceGroup -Name $LocalNetworkGateway
$GatewayIP = $a.GatewayIpAddress
 

If ($PublicIP -ne $GatewayIP) {

    $a.GatewayIpAddress = $PublicIP
    Set-AzLocalNetworkGateway -LocalNetworkGateway $a

}
  
Else {

   $null
    
}