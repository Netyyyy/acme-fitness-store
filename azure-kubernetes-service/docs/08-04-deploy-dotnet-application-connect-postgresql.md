## Introduction

In this guide, we will walk you through the process of deploying the Acme Order application to an Azure Kubernetes Service and connecting it to a PostgreSQL database. To connect the application on AKS to PostgreSQL, it uses the workload identity feature on AKS. See details in [Workload Identity Deploy Cluster](https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster).

## Prerequisites

Before you begin, ensure you have the following:

- Follow [01-create-kubernetes-service](./01-create-kubernetes-service.md) to create Azure Kubernetes Service and Azure Container Registry.
- Follow [07-containerize-application](./07-containerize-application.md) to build the image and push to the Azure Container Registry.
- Follow [06-create-application-supporting-service](./06-create-application-supporting-service.md) to set up the PostgreSQL database.

## Outputs

After completing this guide, you will have:

- Deployed the Acme Order application to your Kubernetes cluster.
- Configured the application to connect to PostgreSQL using Workload Identity.
- Exposed the application within the cluster.

## Steps

1. **Set up the variables**
   Set up the variables used for image and database:
   ```bash
   source resources/var.sh
   az account set -s ${SUBSCRIPTION}

   DATABASE_NAME=acme-order
   IDENTITY_NAME=order-acme-identity

   echo ACR_NAME=${ACR_NAME}
   echo ORDER_SERVICE_APP_IMAGE_TAG=${ORDER_SERVICE_APP_IMAGE_TAG}
   echo DATABASE_NAME=${DATABASE_NAME}
   echo IDENTITY_NAME=${IDENTITY_NAME}
   ```

1. **Create managed identity**

   Create the managed identity for the order service:
   ```bash
   az identity create -n ${IDENTITY_NAME} -g ${RESOURCE_GROUP} --location ${LOCATION} --subscription ${SUBSCRIPTION}
   ```

1. **Connect the managed identity to PostgreSQL**

   Create the database and set up the connection:
   ```bash
   az postgres flexible-server db create --database-name ${DATABASE_NAME} -g ${RESOURCE_GROUP} -s ${POSTGRESQL_NAME}
   az extension add --name serviceconnector-passwordless --upgrade
   AKS_ID=$(az aks show --resource-group ${RESOURCE_GROUP} --name ${AKS_NAME} --query id -o tsv)
   DATABASE_ID=$(az postgres flexible-server db show --server ${POSTGRESQL_NAME} --database-name ${DATABASE_NAME} -g ${RESOURCE_GROUP} --query id -o tsv)
   IDENTITY_ID=$(az identity show -n ${IDENTITY_NAME} -g ${RESOURCE_GROUP} --query id -o tsv)
   az aks connection create postgres-flexible --connection order_acme_postgres --source-id ${AKS_ID} --target-id ${DATABASE_ID} --client-type dotnet --workload-identity ${IDENTITY_ID}
   ```

1. **Get the service account information**

   Retrieve the service account information created by the service connection:
   ```bash
   az aks connection show --connection order_acme_postgres -g ${RESOURCE_GROUP} -n ${AKS_NAME} --query kubernetesResourceName
   ```

   Note there should be 2 resources created:
   - `sc-<connection-name>-secret`: Stores the environment variables indicating the PostgreSQL instance.
   - `sc-account-<client-id>`: Service Account used by Kubernetes resources to authenticate the managed identity.

1. **Edit the resource file**

   Locate the `resources/applications/acme-order.yml` file and update the following placeholders:

   - **`<acr-name>`**: Update to the name of your Azure Container Registry, should be the value of `${ACR_NAME}`.
   - **`<order-service-app-image-tag>`**: Update to the tag of your application image, should be the value of `${ORDER_SERVICE_APP_IMAGE_TAG}`.
   - **`<service-connection-secret>`**: Update to the value of `sc-<connection-name>-secret`.
   - **`<service-connection-service-account>`**: Update to the value of `sc-account-<client-id>`.

   This command will create the following Kubernetes resources:

   1. **ConfigMap**: `order-config`
      - Stores configuration data for the order service.
      - Contains environment variables such as `FOO`.

   2. **Deployment**: `order`
      - Manages the deployment of the order application.
      - Retrieves environment variables from the `order-config` ConfigMap.
      - Uses the `sc-<connection-name>-secret` Secret for PostgreSQL connection configuration.
      - Uses the `<service-connection-service-account>` Service Account as identity to connect PostgreSQL.
      - Configures probes for liveness and readiness to ensure the application is running correctly.
      - Specifies resource limits and requests for CPU, memory, and ephemeral storage.

   3. **Service**: `order-service`
      - Exposes the order application within the Kubernetes cluster.
      - Uses a `ClusterIP` type to provide a stable internal IP address.
      - Routes traffic on port 80 to the application's container port 8080.

1. **Deploy the Application**

   To deploy the application, use the following command:
   ```sh
   kubectl apply -f resources/applications/acme-order.yml
   ```

1. **Verify the deployment**

   Wait for the pod to start running. You can check the status with:
   ```bash
   kubectl get pods
   ```

   You should see output similar to:
   ```
   NAME                        READY   STATUS    RESTARTS   AGE
   order-7656c865bb-4db2p      1/1     Running   0          3m
   ```

   **Tip**: If the pod is not running, check for errors using:
   ```bash
   kubectl describe pod <pod-name>
   kubectl logs <pod-name>
   ```

1. **View the application in .NET Admin**

   Open the hostname for your .NET Admin, you should see the application.

## Next Steps

- Follow [08-05-deploy-python-application-connect-with-redis](./08-05-deploy-python-application-connect-with-redis.md) to deploy the Acme Cart application and connect it to Redis.