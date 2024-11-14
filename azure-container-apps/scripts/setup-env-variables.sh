# Resource group and environment names
RESOURCE_GROUP='rg-myacme'
ENVIRONMENT='env-myacme'
LOCATION='eastus2'

#services name
CATALOG_SERVICE_APP='acme-catalog'
PAYMENT_SERVICE_APP='acme-payment'
ORDER_SERVICE_APP='acme-order'
CART_SERVICE_APP='acme-cart'
FRONTEND_APP='frontend'

# Java components
CONFIG_COMPONENT_NAME='myacmeconfig135'
CONFIG_SERVER_GIT_URI="https://github.com/Azure-Samples/acme-fitness-store-config"
EUREKA_COMPONENT_NAME='myacmeeureka135'
GATEWAY_COMPONENT_NAME='myacmegateway135'
ROUTE_PATH='routes.yml'
ADMIN_COMPONENT_NAME='myacmeadmin135'

# database and cache
AZURE_CACHE_NAME='redis-myacme'
POSTGRES_SERVER_NAME='postgre-myacme'
CATALOG_SERVICE_DB='catalogdb'
CART_SERVICE_CACHE_CONNECTION='cartconnection'
CATALOG_SERVICE_PSQL_CONNECTION='catalogconnection'


# ACR and image tags
ACR_NAME='myacmeacr'
ACR_LOGIN_SERVER=${ACR_NAME}.azurecr.io
CATALOG_SERVICE_APP_IMAGE_TAG="buildpack-catalog"
PAYMENT_SERVICE_APP_IMAGE_TAG="buildpack-payment"
ORDER_SERVICE_APP_IMAGE_TAG="buildpack-order"
CART_SERVICE_APP_IMAGE_TAG="buildpack-cart"
FRONTEND_APP_IMAGE_TAG="buildpack-frontend"