param webbAppName string = 'webb-app1'
param location string = 'eastus'
param appServicePlanName string = 'webb-app'
param appServicePlanSku string = 'F1'
param appServicePlanTier string = 'Free'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {  
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanTier
  }
  properties: {
    perSiteScaling: false
    reserved: false

    }
  } 

resource webbApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webbAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}


output webAppId string = webbApp.id
output webAppDefaultHostName string = webbApp.properties.defaultHostName
