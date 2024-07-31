param vnetName string = 'vnet1'
param location string = 'eastus'
param addressPrefix string = '10.0.0.0/16'
param subnetName string = 'subnet1'
param subnetPrefix string = '10.0.0.0/24'
param publicIP string = 'publicip1'
param nicName string = 'nic1'

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2018-10-01' = {
  name: vnetName
  location: location
  properties: {  
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

// Subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2018-10-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefix: subnetPrefix
  }
}

// Public IP Address
resource publicIp 'Microsoft.Network/publicIPAddresses@2018-10-01' = {
  name: publicIP
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Interface Card
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
            id: subnet.id
          }
        }
      }
    ]
  }
}
