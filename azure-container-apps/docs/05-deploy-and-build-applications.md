# Deploy and Build Applications
## Introduction
This guide shows you how to deploy and build applications on Azure Container Apps.

## Prerequisites
- Completion of [04-containerize-application](./04-containerize-application.md).

## Outputs
After completing this guide, you will have 5 container services:
- Acme Frontend application.
- Exposed the application within the cluster and made it discoverable by Spring Cloud Gateway.

## Steps

### 1. Set up the variables
Set up the variables to deploy container apps:
```bash
source azure-container-apps/scripts/setup-env-variables.sh

echo "ACR_NAME=${ACR_NAME}"
echo "ACR_LOGIN_SERVER=${ACR_LOGIN_SERVER}"
echo "CATALOG_SERVICE_APP=${CATALOG_SERVICE_APP}"
echo "PAYMENT_SERVICE_APP=${PAYMENT_SERVICE_APP}"
echo "ORDER_SERVICE_APP=${ORDER_SERVICE_APPq}"
echo "CART_SERVICE_APP=${CART_SERVICE_APP}"
echo "FRONTEND_APP=${FRONTEND_APP}"
```

### 2. Assign role to the Azure Container Apps Environment
1. Get resource ID of the user-assigned identity:
```bash
export USERID=$(az containerapp env show --resource-group ${RESOURCE_GROUP} --name ${ENVIRONMENT} --query id --output tsv)
```

2. Get service principal ID of the user-assigned identity:
```bash
export SPID=$(az containerapp env show --resource-group ${RESOURCE_GROUP} --name ${ENVIRONMENT} --query identity.principalId --output tsv)
```

3. Assign role to the system-assigned managed identity of the created Azure Container Apps Environment:
```bash
az role assignment create --assignee ${SPID} --scope ${USERID} --role acrpull
```

### 3. Deploy the Application
1. Deploy the Payment service:
```bash
az containerapp create --name ${PAYMENT_SERVICE_APP} --resource-group ${RESOURCE_GROUP} --environment ${ENVIRONMENT} --image ${ACR_LOGIN_SERVER}/${PAYMENT_SERVICE_APP}:${PAYMENT_SERVICE_APP_IMAGE_TAG} --min-replicas 1 --ingress external --target-port 8080 --bind ${CONFIG_COMPONENT_NAME} ${EUREKA_COMPONENT_NAME} --registry-server ${ACR_LOGIN_SERVER} --registry-identity system
```

2. Deploy the Catalog Service and export the URL for next steps:
```bash
export CATALOG_SERVICE_URL=$(az containerapp create --name ${CATALOG_SERVICE_APP} --resource-group ${RESOURCE_GROUP} --environment ${ENVIRONMENT} --image ${ACR_LOGIN_SERVER}/${CATALOG_SERVICE_APP}:${CATALOG_SERVICE_APP_IMAGE_TAG} --min-replicas 1 --ingress external --target-port 8080 --bind ${CONFIG_COMPONENT_NAME} ${EUREKA_COMPONENT_NAME} --registry-server ${ACR_LOGIN_SERVER} --registry-identity system --query properties.configuration.ingress.fqdn --output tsv)
```

3. Deploy the Order Service and export the URL for next steps:
```bash
export ORDER_SERVICE_URL=$(az containerapp create --name ${ORDER_SERVICE_APP} --resource-group ${RESOURCE_GROUP} --environment ${ENVIRONMENT} --image ${ACR_LOGIN_SERVER}/${ORDER_SERVICE_APP}:${ORDER_SERVICE_APP_IMAGE_TAG} --min-replicas 1 --ingress external --target-port 8080 --registry-server ${ACR_LOGIN_SERVER} --registry-identity system --query properties.configuration.ingress.fqdn --output tsv)
```

4. Deploy the Cart Service and export the URL for next steps:
```bash
export CART_SERVICE_URL=$(az containerapp create --name ${CART_SERVICE_APP} --resource-group ${RESOURCE_GROUP} --environment ${ENVIRONMENT} --image ${ACR_LOGIN_SERVER}/${CART_SERVICE_APP}:${CART_SERVICE_APP_IMAGE_TAG} --min-replicas 1 --ingress external --target-port 8080 --env-vars CART_PORT=8080 --registry-server ${ACR_LOGIN_SERVER} --registry-identity system --query properties.configuration.ingress.fqdn --output tsv)
```

5. Deploy the Frontend Service and export the URL for next steps:
```bash
export FRONTEND_URL=$(az containerapp create --name ${FRONTEND_APP} --resource-group ${RESOURCE_GROUP} --environment ${ENVIRONMENT} --image ${ACR_LOGIN_SERVER}/${FRONTEND_APP}:${FRONTEND_APP_IMAGE_TAG} --min-replicas 1 --ingress external --target-port 8080 --bind ${CONFIG_COMPONENT_NAME} ${EUREKA_COMPONENT_NAME} --registry-server ${ACR_LOGIN_SERVER} --registry-identity system --query properties.configuration.ingress.fqdn --output tsv)
```

## Next Steps

- Follow [06-create-gateway-server](./06-create-gateway-server.md) to create a Gateway Server on Azure Container Apps Environment.