function Connect-Azure
 {
   <#
       .SYNOPSIS
       Connect-Azure Function to login to Azure - using Resource Groups.
       .DESCRIPTION
       Prompts for Azure user credentials, prompts to select Azure Subscription and passes through to select an Azure subscrption.
       .EXAMPLE
       Connect-Azure
       .AUTHOR: Luke Murray (Luke.geek.nz)
       .VERSION: 0.1
   #>
   Import-Module -Name AzureRM

   #Authenticate to Azure with Azure RM credentials

   Add-AzureRmAccount

   #Select Azure Subscription
   Get-AZureRMSubscription|Out-GridView -PassThru|Select-AzureRmSubscription
 }
 Connect-Azure


$resources = Get-AzureRMResource | Select-Object ResourceType

$results = @()

foreach ($resource in $resources)

{
 $a = Get-AzureRmResource -ResourceType $resource.ResourceType

    $results += [pscustomobject]@{
    'Count' = $a.Count
    'Resource' = $resource.ResourceType
  }
}


$results | export-csv c:\temp\AzureResources.csv
