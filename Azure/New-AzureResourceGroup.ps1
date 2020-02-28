function New-AzureResourceGroup
{
  <#
    .SYNOPSIS
    Creates Azure Resource Group
    .DESCRIPTION
    Creates Azure Resource Group
    .EXAMPLE
    New-AzureResourceGroup
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $Name = 'RG01',
    [Parameter(Mandatory=$false, Position=1)]
    [System.String]
    $Location = 'Australia East'
  )
  
  $tenantId = (Get-StoredCredential -Target 'MSDN SPN Demo').GetNetworkCredential().UserName 
  $pscredential = (Get-StoredCredential -Target 'MSDN SPN Demo Key')
  
  Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId
  
  New-AzResourceGroup -Name $Name -Location $Location -Tag @{Empty=$null; Department="Marketing"}
}

New-AzureResourceGroup -Name $Name -Location $Location
