param location string = 'eastus'
@minLength(3)
@maxLength(24)
@description('Provide a name for the storage account. The name must be between 3 and 24 characters long.')
param storageAccountName string = 'ssjstorageaccount'
@description('Name of the resource group containing the virtual network')
param vnetResourceGroupName string = 'myResourceGroup'
@description('Name of the virtual network')
param vnetName string = 'myVnet'
@description('Name of the subnet')
param subnetName string = 'mySubnet'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    accessTier: 'Cool'
    networkAcls:{
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: resourceId(vnetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
        }
      ]
      ipRules:[
        {
          value: '123.123.123'
        }
      ]
      defaultAction: 'Deny'
    }
  }
  tags: {
    environment: 'test'
    department: 'IT'
  }
}

  
    

