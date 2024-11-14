# Get Log and Metrics
## Introduction
This document provides instructions on how to view logs and metrics for your Azure Container Apps. By following these steps, you will be able to monitor your containerized applications effectively. For more details, see [Observability in Azure Container Apps](https://learn.microsoft.com/azure/container-apps/observability).

## Prerequisites
- Deploy at least one application on the Azure Container Apps from previous guidance.

## Steps

### 1. View Logs
Use the following command to view logs for your Azure Container App:
```bash
az containerapp logs show --name <container app name> --resource-group ${RESOURCE_GROUP} --follow
```
More details can be found in the [official documentation](https://learn.microsoft.com/azure/container-apps/logging).

### 2. View Metrics
See [Monitor Azure Container Apps metrics](https://learn.microsoft.com/azure/container-apps/metrics).
