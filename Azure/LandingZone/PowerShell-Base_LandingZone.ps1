$companyname = 'lukegeeknz'
$location = 'australiaeast'
$backupstorageRedundancy = 'LocallyRedundant'

## Suppress breaking change warning messages
 
Set-Item -Path Env:\SuppressAzurePowerShellBreakingChangeWarnings -Value 'true'
 
# Register the Azure Recovery Service provider with your subscription (only necessary if you use Azure Backup for the first time)
 
Register-AzResourceProvider -ProviderNamespace 'Microsoft.RecoveryServices'

# Register the Azure providers for future Azure Image Builder deployments with your subscription

Register-AzResourceProvider -ProviderNamespace 'Microsoft.Security'
Register-AzResourceProvider -ProviderNamespace 'Microsoft.VirtualMachineImages'
Register-AzResourceProvider -ProviderNamespace 'Microsoft.Compute'
Register-AzResourceProvider -ProviderNamespace 'Microsoft.KeyVault'
Register-AzResourceProvider -ProviderNamespace 'Microsoft.Storage'
Register-AzResourceProvider -ProviderNamespace 'Microsoft.Network'

Set-AzSecurityPricing -Name "default" -PricingTier "Free"

#Creating Azure Network Resource Group

Get-AzResourceGroup -Name "$companyname-network-rg-au-e-prod" -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name "$companyname-network-rg-au-e-prod" -Location "$location"
}
else {
    Write-Verbose -Message 'Resource Group already exists.'
}

#Creating Azure Management Resource Group

Get-AzResourceGroup -Name "$companyname-azmanage-rg-au-e-prod" -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name "$companyname-azmanage-rg-au-e-prod" -Location "$location"
}
else {
    Write-Verbose -Message 'Resource Group already exists.'
}

#Creating Azure Backup Resource Group

Get-AzResourceGroup -Name "$companyname-backup-rg-au-e-prod" -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name "$companyname-backup-rg-au-e-prod" -Location "$location"
}
else {
    Write-Verbose -Message 'Resource Group already exists.'
}

#Create Diagnostic Account
$diag = "diagstgprod"
New-AzStorageAccount -ResourceGroupName "$companyname-azmanage-rg-au-e-prod" -AccountName "$companyname$diag" -Location $location -SkuName Standard_LRS -Kind Storage

#Creates Log Analytic Workspace

New-AzOperationalInsightsWorkspace -Location $location -Name "$companyname-azmanage-la-au-e-prod" -Sku free -ResourceGroupName "$companyname-azmanage-rg-au-e-prod"

#Creates Azure KeyVault
New-AzKeyVault -VaultName "$companyname-azmanage-kv-au-e-prod" -ResourceGroupName "$companyname-azmanage-rg-au-e-prod" -Location $location

#Creates Network Watcher

New-AzNetworkWatcher -Name "NetworkWatcher_$location" -ResourceGroupName "$companyname-network-rg-au-e-prod" -Location $location

#Creates Azure Virtual Network

Get-AzVirtualNetwork -Name "$companyname-production-vn-au-e-prod" -ResourceGroupName "$companyname-network-rg-au-e-prod" -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    Write-Verbose -Message 'Creating Virtual Network...'
    $vnet = @{
        Name              = "$companyname-production-vn-au-e-prod"
        ResourceGroupName = "$companyname-network-rg-au-e-prod"
        Location          = "$location"
        AddressPrefix     = '10.100.0.0/16'
    } 
}
        
$virtualNetwork = New-AzVirtualNetwork @vnet
        
     
        
$gwsubnet = @{
    Name           = 'GatewaySubnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix  = '10.100.1.0/26'
} 
        
Add-AzVirtualNetworkSubnetConfig @gwsubnet 
        
         
        
$azbastionsubnet = @{
    Name           = 'AzureBastionSubnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix  = '10.100.1.64/27'
} 
        
Add-AzVirtualNetworkSubnetConfig @azbastionsubnet 
                 
$azfwsubnet = @{
    Name           = 'AzureFirewallSubnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix  = '10.100.1.128/26'
} 
        
Add-AzVirtualNetworkSubnetConfig @azfwsubnet 
        

$appsrvsubnet = @{
    Name           = "$companyname-appservers-snet-au-e-prod"
    VirtualNetwork = $virtualNetwork
    AddressPrefix  = '10.100.2.0/24'
} 

Add-AzVirtualNetworkSubnetConfig @appsrvsubnet

$dbsrvsubnet = @{
    Name           = "$companyname-dbservers-snet-au-e-prod"
    VirtualNetwork = $virtualNetwork
    AddressPrefix  = '10.100.3.0/24'
} 
   
Add-AzVirtualNetworkSubnetConfig @dbsrvsubnet
            
$virtualNetwork | Set-AzVirtualNetwork 


#Create Azure Network Security Groups and assign to the subnets

$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName "$companyname-network-rg-au-e-prod" `
    -Location "$location" `
    -Name "$companyname-appservers-nsg-au-e-prod"

Get-AzVirtualNetwork -Name "$companyname-production-vn-au-e-prod" -ResourceGroupName "$companyname-network-rg-au-e-prod" | Set-AzVirtualNetworkSubnetConfig  -Name "$companyname-appservers-snet-au-e-prod" `
    -AddressPrefix '10.100.2.0/24' `
    -NetworkSecurityGroup $nsg | Set-AzVirtualNetwork

$nsg = New-AzNetworkSecurityGroup `
    -ResourceGroupName "$companyname-network-rg-au-e-prod" `
    -Location "$location" `
    -Name "$companyname-dbservers-nsg-au-e-prod" `

Get-AzVirtualNetwork -Name "$companyname-production-vn-au-e-prod" -ResourceGroupName "$companyname-network-rg-au-e-prod" | Set-AzVirtualNetworkSubnetConfig -Name "$companyname-dbservers-snet-au-e-prod" `
    -AddressPrefix "10.100.3.0/24" -NetworkSecurityGroup $nsg | Set-AzVirtualNetwork



# Creating Azure Backup Recovery Vault Group

Get-AzRecoveryServicesVault -Name "$companyname-rsv-au-e-prod" -ResourceGroupName "$companyname-backup-rg-au-e-prod" -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {

    New-AzRecoveryServicesVault -Name "$companyname-rsv-au-e-prod" -ResourceGroupName "$companyname-backup-rg-au-e-prod" -Location $location 
    Get-AzRecoveryServicesVault -Name "$companyname-rsv-au-e-prod" -ResourceGroupName "$companyname-backup-rg-au-e-prod" |  Set-AzRecoveryServicesBackupProperty -BackupStorageRedundancy $backupstorageRedundancy
    
}
else {
    Write-Host "Backup Vault already exists."
}