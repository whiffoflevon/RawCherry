param aksClusterName string = 'aks-cluster'
param location string = 'eastus'
param nodeCount int = 2 
param nodeVMSize string = 'Standard_DS2_v2'
param vnetName string = 'aks-vnet'  
param subnetName string = 'aks-subnet'
param dnsPrefix string = 'aks-cluster'
@secure()
param servicePrincipalClientId string
@secure()
param servicePrincipalClientSecret string


resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

 
resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksClusterName
  location: location
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: nodeCount
        vmSize: nodeVMSize
        osType: 'Linux'
        vnetSubnetID:vnet.properties.subnets[0].id // reference to the subnet
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
    }
    servicePrincipalProfile: {
      clientId: servicePrincipalClientId
      secret: servicePrincipalClientSecret
    }
  }
}

output aksClusterId string = aksCluster.id
output aksClusterFqdn string = aksCluster.properties.fqdn
