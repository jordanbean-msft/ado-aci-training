param longName string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'la-${longName}'
  location: resourceGroup().location
}

output logAnalyticsWorkspaceName string = logAnalytics.name
