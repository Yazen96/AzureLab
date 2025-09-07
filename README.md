Azure Infrastructure Deployment with Bicep – Lab 2


I started by creating a Bicep project with a modular structure.
I wrote separate module files for the storage account, the app service plan with web app and Key Vault, and a resource group module to show that I know how to create one.
Even though I didn’t use it in the deployment since I deployed everything to my personal resource group.

I created a main Bicep file that connects the storage and app service modules.
I used parameters to keep the code clean and reusable. Then I created three parameter files, one for each environment: dev, test, and prod.
Each file includes environment-specific values such as names, SKUs, tags, and secret values.

I deployed all three environments into the same resource group: RG-yazanalnsierat.
For each environment, I deployed a Storage Account with kind StorageV2 and SKU Standard_LRS.
I also created an App Service Plan, using B1 for dev and test, and S1 for prod. For the production environment, I added autoscale settings.

Each environment includes a Web App that has HTTPS-only enabled.
I also created a Key Vault for each environment and passed in a secret through the parameter file.
In the web app configuration, I referenced the Key Vault secret using app settings.
To handle secrets securely, I used the `@secure()` attribute in the Bicep files.

I tagged all resources with owner, environment, and costCenter to support cost tracking and good resource management.
Finally, I deployed the environments successfully and verified that everything is working.
All three web apps are live and running.

All parameters such as names, SKUs, and locations are passed through parameter files and nothing is hardcoded in the Bicep files.

Web App URLs per environment:

- Dev: https://lab2adminstclouddev.azurewebsites.net  
- Test: https://lab2adminstcloudtest.azurewebsites.net  
- Prod: https://lab2adminstcloudprod.azurewebsites.net

How to Deploy

To test or deploy the solution, I used the following commands in Azure CLI:
az login

az account set --subscription ".NET Cloud Developer 2024"

Deploy Dev:
az deployment group create \
  --resource-group RG-yazanalnsierat \
  --template-file main.bicep \
  --parameters @parameters/dev.json

  Deploy Test:
  az deployment group create \
  --resource-group RG-yazanalnsierat \
  --template-file main.bicep \
  --parameters @parameters/test.json

  Deploy prod:
  az deployment group create \
  --resource-group RG-yazanalnsierat \
  --template-file main.bicep \
  --parameters @parameters/prod.json
