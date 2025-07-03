# Spatial Enrich Dashboard

## 🚀 Motivation

### 1. **Flexible Deployment**
Spatial Enrich Dashboard is delivered as a set of microservices running in individual Kubernetes pods via container-based delivery.  
These containers are orchestrated by Kubernetes, ensuring efficient workload distribution across a cluster.

### 2. **Elastic Scaling & Clustering**
Scale environments based on usage:
- Scale for high daytime application load.
- Manually or auto-scale via CLI or Kubernetes dashboard.

### 3. **High Availability**
- Kubernetes ensures pod health checks and auto-recovery for mission-critical scenarios.
- Leverages K8s monitoring tools to track resource usage and availability.

### 4. **Automated Rollbacks & Rollouts**
- Deploy from container registries.
- Kubernetes allows progressive rollout of updates and changes.
- In case of failure, Kubernetes automatically rolls back.
- Infrastructure is optimized for actual usage—minimizing total cost of ownership.

### 5. **Portability**
- Deploy on-premise or to any major cloud provider.
- Seamlessly supports multi-cloud environments.

> **Note:**  
> This solution is designed for users seeking a Kubernetes-based deployment for the Spatial Enrich Dashboard.

> [!IMPORTANT]  
> The provided Helm charts come with default configurations and are **recommendations only**.  
> You should tailor these configurations to match your specific use case and environment requirements.

---

## 📘 Guides

- **Quickstart Guide:**  
  [EKS](./docs/guides/eks/QuickStartEKS.md) | [GKE](./docs/guides/gke/QuickStartGKE.md) | [AKS](./docs/guides/aks/QuickStartAKS.md)

- **Uninstall Guide:**  
  [EKS](./docs/guides/eks/UninstallGuide.md) | [GKE](./docs/guides/gke/UninstallGuide.md) | [AKS](./docs/guides/aks/UninstallGuide.md)

---

## 📦 Installing the Spatial Enrich Dashboard Chart

### 1️⃣ Prepare Your Environment
Install Client tools required for installation. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-1-prepare-your-environment) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-1-setup-cloud-shell) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-1-prepare-your-environment)

### 2️⃣ Create a Kubernetes Cluster
 Create or use an existing K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-2-create-k8s-cluster-eks) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-2-create-k8s-cluster-gke) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-2-create-k8s-cluster-aks)

### 3️⃣ Download Spatial Enrich Dashboard Images
Download docker images and upload to own container registry. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-3-download-spatial-enrich-dashboard-docker-images) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-3-download-spatial-enrich-dashboard-docker-images) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-3-download-spatial-enrich-dashboard-docker-images)

### 4️⃣ Install the Helm Chart
Deploy Spatial Enrich Dashboard chart to K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-4-installation-of-spatial-enrich-dashboard-helm-chart) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-4-installation-of-spatial-enrich-dashboard-helm-chart) | [AKS](./docs/guides/aks/QuickStartAKS.md#step-4-installation-of-spatial-enrich-dashboard-helm-chart)
