param vnetName string = 'vnet1'
param location string = 'eastus'
param addressPrefix string = '10.0.0.0/16'
param subnetName string = 'subnet1'
param subnetPrefix string = '10.0.0.0/24'
param publicIP string = 'publicip1'
param nicName string = 'nic1'

resource vnet 'Microsoft.Network/virtualNetworks@2018-10-01' = {
  name: vnetName
  location: location // VirtualNetworks must be in the same region as the containing resource group
  properties: {  
    addressSpace: {
      addressPrefixes:[
        addressPrefix
 
      ]
    }
  }
} 


resource publicIp 'Microsoft.Network/publicIPAddresses@2018-10-01' = {
  name: publicIP
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2018-10-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefix: subnetPrefix
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
        }
      }
    ]
  }
}

