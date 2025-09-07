targetScope = 'resourceGroup'

param location string
param environment string
param owner string
param costCenter string
param storageAccountName string
param appServicePlanSku string
param appServicePlanName string
param webAppName string
param keyVaultName string
@secure()
param secretValue string

var tags = {
  owner: owner
  environment: environment
  costCenter: costCenter
}

module storage 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: tags
  }
}

module app 'modules/appservice.bicep' = {
  name: 'appDeploy'
  params: {
    location: location
    appServicePlanSku: appServicePlanSku
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    keyVaultName: keyVaultName
    secretValue: secretValue
    tags: tags
  }
}

output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
