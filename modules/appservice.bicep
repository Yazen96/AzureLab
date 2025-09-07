param location string
param appServicePlanSku string
param appServicePlanName string
param webAppName string
param keyVaultName string
@secure()
param secretValue string
param tags object

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanSku == 'S1' ? 'Standard' : 'Basic'
  }
  tags: tags
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'MY_SECRET'
          value: secretValue
        }
      ]
    }
  }
  tags: tags
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    enabledForDeployment: true
    enableRbacAuthorization: true
  }
  tags: tags
}

resource autoscale 'Microsoft.Insights/autoscalesettings@2022-10-01' = if (appServicePlanSku == 'S1') {
  name: '${appServicePlanName}-autoscale'
  location: location
  properties: {
    profiles: [
      {
        name: 'AutoScaleProfile'
        capacity: {
          minimum: '1'
          maximum: '3'
          default: '1'
        }
        rules: []
      }
    ]
    targetResourceUri: appServicePlan.id
    enabled: true
  }
}
