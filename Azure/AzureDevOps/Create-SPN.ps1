#requires -Version 3.0

#Azure Application , creates SPN, assigns Contributor to subscription then adds Service Connection into Azure DevOps.

$AppRegName = 'SPN.Sub.Contributor'
$env:AZURE_DEVOPS_EXT_PAT = '1111111111111111111111111'
$azDevOpsOrgUrl = 'https://dev.azure.com/orgname/'
$azDevOpsProjName = 'ProjectA'

#Connects to Microsoft Azure

az.cmd login

$SUBSCRIPTION_ID = az.cmd account show --query id --output tsv
$SUBSCRIPTION_NAME = az.cmd account show --query name --output tsv

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Create SPN
  
$spn = az.cmd ad sp create-for-rbac --name $AppRegName --role 'contributor'

$spndetails = $spn | ConvertFrom-Json | Select-Object -Property password, tenant, appId

# Create Azure DevOps Service Connections
    
# Gets the password for the SPN and places it in a variable which will be loaded automatically .
  
$env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY = $spndetails.password
  
$azDevOpsServiceConnName = $AppRegName
  
Write-Host Creating New Service Connection $azDevOpsServiceConnName in Project $azDevOpsProjName -ForegroundColor Cyan
    
az.cmd devops service-endpoint azurerm create --azure-rm-service-principal-id  $spndetails.appId `
--azure-rm-subscription-id $SUBSCRIPTION_ID `
--azure-rm-subscription-name $SUBSCRIPTION_NAME `
--azure-rm-tenant-id $spndetails.tenant `
--name $azDevOpsServiceConnName `
--organization $azDevOpsOrgUrl `
--project $azDevOpsProjName

Write-Host New Service Connection named:$azDevOpsServiceConnName has been created in Project $azDevOpsProjName -ForegroundColor Cyan
   
#Clear out Env Variables
    
$env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY = $null
$env:AZURE_DEVOPS_EXT_PAT = $null
