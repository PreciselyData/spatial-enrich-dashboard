# spatial-enrich-dashboard
## Motivation

1. **Flexibility of deployment**

   Private Spatial APIs are delivered as separate microservices in multiple Kubernetes pods using container-based delivery.
   Containers are orchestrated by Kubernetes with efficient distribution of workloads across a cluster of computers.

2. **Elastic scaling and clusterings**

   Scale according to use cases (for example environments can scale up for overnight tile caching, scale up to meet
   application usage during the day). Autoscaling or manual scaling via command line or K8s dashboard. Major APIs
   such as Mapping, Tiling and Feature services can be separately scaled to match requirements.

3. **High availability**

   Kubernetes handles pod health checks and ensures cluster is resilient for mission critical cases, providing
   auto failover. K8s monitoring tools for health and availability and server resource usage.

4. **Automatic rollbacks & rollouts**

   Deployed from container registry. Ease of deployment and upgrades. Kubernetes can progressively roll out updates
   and changes to your app or its configuration. If something goes wrong, Kubernetes can and will roll back the change.
   Optimised infrastructure costs: Scale for usage rather than maximum anticipated capacity. Pricing model will reflect usage,
   hence cost of ownership can be reduced to match actual demand.

5. **Portability**

   Can be deployed on premise or to a cloud provider. Portability and flexibility in multi-cloud environments.

> This solution is specifically for users who are looking for a Spatial Enrich Dashboard  and Kubernetes based deployments.

> [!IMPORTANT]  
> Please consider these helm charts as recommendations only. They come with predefined configurations that may not be the best fit for your needs. Configurations can be tweaked based on the use case and requirements.

## Guides
- Quickstart Guide: [EKS](./docs/guides/eks/QuickStartEKS.md) | [GKE](./docs/guides/gke/QuickStartGKE.md) | [AKS](./docs/guides/aks/QuickStartAKS.md)
- Uninstall Guide: [EKS](./docs/guides/eks/UninstallGuide.md) | [GKE](./docs/guides/gke/UninstallGuide.md) | [AKS](./docs/guides/aks/UninstallGuide.md) 

## Installing Spatial Enrich dashboard Chart
### 1. Prepare your environment
Install Client tools required for installation. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-1-prepare-your-environment) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-1-setup-cloud-shell) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-1-prepare-your-environment)

### 2. Create K8s cluster
Create or use an existing K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-2-create-k8s-cluster-eks) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-2-create-k8s-cluster-gke) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-2-create-k8s-cluster-aks)

### 3. Download Private Spatial APIs Images
Download docker images and upload to own container registry. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-3-download-private-spatial-apis-docker-images) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-3-download-private-spatial-apis-docker-images) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-3-download-private-spatial-apis-docker-images)

### 4. Install Spatial Enrich Dashboard Helm Chart
Deploy Private Spatial APIs chart to K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-4-installation-of-private-spatial-apis-helm-chart) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-4-installation-of-private-spatial-apis-helm-chart) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-4-installation-of-private-spatial-apis-helm-chart)