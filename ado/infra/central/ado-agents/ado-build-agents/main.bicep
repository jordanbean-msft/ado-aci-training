param appName string
param environment string
param location string
param containerRegistryName string
param imageName string
param imageVersion string
param numberOfContainersToCreate int
param azpPool string
param azpToken string
param azpUrl string

var longName = '${appName}-${location}-${environment}'

module containerInstance 'aci.bicep' = {
  name: 'aciDeployment'
  params: {
    longName: longName
    containerRegistryName: containerRegistryName
    imageName: imageName
    imageVersion: imageVersion
    numberOfContainersToCreate: numberOfContainersToCreate
    azpPool: azpPool
    azpToken: azpToken
    azpUrl: azpUrl
  }
}
