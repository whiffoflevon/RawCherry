param sqlServerName string = 'sqlserver'
param location string = 'East US'
param sqlServerDatabase string = 'master'
param sqlServerUsername string = 'sa'
@secure()
param sqlServerPassword string 

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' ={
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerUsername
    administratorLoginPassword: sqlServerPassword
    version: '12.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: sqlServerDatabase
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824 // 1 GB
  }
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
} 

output sqlServerId string = sqlServer.id
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDatabaseId string = sqlDatabase.id
