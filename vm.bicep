param location string = 'eastus'
@minLength(3)
@maxLength(63)
@description('The name of the virtual machine.')
param vmName string = 'myVM'
@minLength(3)
@maxLength(63)
@description('Username of the user for the virtual machine.')
param adminUsername string = 'azureuser'
@description('Password of the user for the virtual machine.')
@secure()
param adminPassword string


resource publicIp 'Microsoft.Network/publicIPAddresses@2018-10-01' = {
  name: 'publicIp'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  
  }
}

      
resource nic 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: 'nic1'
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


        
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2018-10-01' = {
  name: 'nsg1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2018-10-01' ={
  name: 'vm1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
   osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword 
   }
   storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04.0-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
      }
    }
  }
  networkProfile: {
    networkInterfaces: [
      {
        id: nic.id
      }
    ]
  }
}
}

