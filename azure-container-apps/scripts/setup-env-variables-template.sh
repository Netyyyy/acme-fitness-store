# Resource group and environment names
SUBSCRIPTION='subscription-id'                 # replace it with your subscription-id
RESOURCE_GROUP='resource-group-name'           # existing resource group or one that will be created in next steps
ENVIRONMENT='azure-container-apps-environment' # name of the environment that will be created in the next steps
LOCATION='eastus2'

#services name
CATALOG_SERVICE_APP='acme-catalog'
PAYMENT_SERVICE_APP='acme-payment'
ORDER_SERVICE_APP='acme-order'
CART_SERVICE_APP='acme-cart'
FRONTEND_APP='frontend'

# Java components
CONFIG_COMPONENT_NAME='myacmeconfig'
CONFIG_SERVER_GIT_URI="https://github.com/Azure-Samples/acme-fitness-store-config"
EUREKA_COMPONENT_NAME='myacmeeureka'
GATEWAY_COMPONENT_NAME='myacmegateway'
ROUTE_PATH='routes.yml'
ADMIN_COMPONENT_NAME='myacmeadmin'

# database and cache
AZURE_CACHE_NAME='redis-myacme'
POSTGRES_SERVER_NAME='postgre-myacme'
CATALOG_SERVICE_DB='catalogdb'
CART_SERVICE_CACHE_CONNECTION='cartconnection'
CATALOG_SERVICE_PSQL_CONNECTION='catalogconnection'


# ACR and image tags
ACR_NAME='azure-container-registry-name'       # existing ACR or one that will be created in next steps
ACR_LOGIN_SERVER=${ACR_NAME}.azurecr.io
APP_IMAGE_TAG="latest"
