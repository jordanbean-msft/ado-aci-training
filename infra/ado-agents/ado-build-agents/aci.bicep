param azpPool string
@secure()
param azpToken string
param azpUrl string
param containerRegistryName string
param imageName string
param imageVersion string
param logAnalyticsWorkspaceName string
param longName string
param numberOfContainersToCreate int

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: containerRegistryName
}

resource containerInstance 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: 'aci-${longName}'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    containers: [for i in range(0, numberOfContainersToCreate): {
        name: '${imageName}${i}'
        properties: {
          image: '${containerRegistry.name}.azurecr.io/${imageName}:${imageVersion}'
          environmentVariables: [
            {
              name: 'AZP_TOKEN'
              secureValue: azpToken
            }
            {
              name: 'AZP_URL'
              value: azpUrl
            }
            {
              name: 'AZP_POOL'
              value: azpPool
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 4
            }
          }
        }
      }]
    osType: 'Linux'
    restartPolicy: 'Never'
    imageRegistryCredentials: [
      {
        server: '${containerRegistry.name}.azurecr.io'
        username: listCredentials(containerRegistry.id, containerRegistry.apiVersion).username
        password: listCredentials(containerRegistry.id, containerRegistry.apiVersion).passwords[0].value
      }
    ]
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource containerInstanceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'Logging'
  scope: containerInstance
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'ContainerRegistryRepositoryEvents'
        enabled: true
      }
      {
        category: 'ContainerRegistryLoginEvents'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output containerInstanceName string = containerInstance.name
