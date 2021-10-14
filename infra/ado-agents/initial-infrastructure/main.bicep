param appName string
param environment string
param location string

var longName = '${appName}-${location}-${environment}'

module loggingDeployment 'logging.bicep' = {
  name: 'loggingDeployment'
  params: {
    longName: longName
  }
}

module containerRegistry 'acr.bicep' = {
  name: 'acrDeployment'
  params: {
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    longName: longName
  }
}

output logAnalyticsWorkspaceName string = loggingDeployment.outputs.logAnalyticsWorkspaceName
output containerRegistryName string = containerRegistry.outputs.containerRegistryName
