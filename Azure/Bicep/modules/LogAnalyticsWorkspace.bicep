@description('The name of the Azure workspace')
param workspace_name string = ''


@allowed([
  'pergb2018'
  'free'
])
@description('Specify the SKU of the Log Analytics Workspace')
param sku string = 'free'

@description('Optional. Tags of the storage account resource.')
param tags object = {}

resource workspace_name_resource 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspace_name
  location: 'australiaeast'
  tags: tags
  properties: {
      sku: sku
      retentionInDays: 30
      features: {
        immediatePurgeDataOn30Days: true
      }
    }

  }

  output workspacemame string = workspace_name_resource.name
  output workspacemameid string = workspace_name_resource.id
  