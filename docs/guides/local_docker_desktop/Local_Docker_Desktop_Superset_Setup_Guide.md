# Installing the Spatial Enrich Dashboard Helm Chart on Local Docker Desktop Kubernetes

## **Before starting**

Make sure you have the following items before starting:

- Docker Desktop installed with Kubernetes enabled.
- kubectl installed.
- Helm installed.
- Spatial Enrich Dashboard Docker image tar file (`spatial-enrich-dashboard.tar`).
- Spatial Enrich Dashboard Helm chart source.

This setup uses:
- Docker Desktop Kubernetes
- Local Docker images
- Helm chart deployment

---

# Preview

- [Step 1: Prepare your environment](#step-1-prepare-your-environment)
- [Step 2: Enable Kubernetes in Docker Desktop](#step-2-enable-kubernetes-in-docker-desktop)
- [Step 3: Load Spatial Enrich Dashboard Docker Image](#step-3-load-spatial-enrich-dashboard-docker-image)
- [Step 4: Verify Docker Image](#step-4-verify-docker-image)
- [Step 5: Configure Helm Values](#step-5-configure-helm-values)
- [Step 6: Install Spatial Enrich Dashboard Helm Chart](#step-6-install-spatial-enrich-dashboard-helm-chart)
- [Step 7: Verify Deployment](#step-7-verify-deployment)
- [Step 8: Access the Dashboard](#step-8-access-the-dashboard)
- [Step 9: Troubleshooting](#step-9-troubleshooting)

---

# Step 1: Prepare your environment

Install the following tools:

- Docker Desktop
- kubectl
- Helm

Verify installations:

```shell
docker version
```

```shell
kubectl version --client
```

```shell
helm version
```

Clone the Spatial Enrich Dashboard repository:

```shell
git clone https://github.com/PreciselyData/spatial-enrich-dashboard.git
```

---

# Step 2: Enable Kubernetes in Docker Desktop

Open Docker Desktop.

Go to:

```text
Settings → Kubernetes
```

Enable:

```text
Enable Kubernetes
```

Click:

```text
Apply & Restart
```

Wait until Kubernetes becomes ready.

Verify Kubernetes:

```shell
kubectl get nodes
```

Expected output:

```shell
NAME               STATUS   ROLES           AGE   VERSION
docker-desktop     Ready    control-plane   ...
```

---

# Step 3: Load Spatial Enrich Dashboard Docker Image

Place the provided Docker image tar file:

```text
spatial-enrich-dashboard.tar
```

inside a working directory.

Load the image:

```shell
docker load -i spatial-enrich-dashboard.tar
```

Example output:

```shell
Loaded image: spatial-enrich-dashboard:latest
```

---

# Step 4: Verify Docker Image

List images:

```shell
docker images
```

Expected:

```shell
REPOSITORY                  TAG       IMAGE ID
spatial-enrich-dashboard    latest    xxxxxxxxx
```

Create a local tag:

```shell
docker tag spatial-enrich-dashboard:latest spatial-enrich-dashboard:v1
```

Verify:

```shell
docker images
```

---

## Disable Example Loading (Recommended)

Because some custom images may not contain Superset example datasets, disable loading examples:

```yaml
init:
  loadExamples: false
```

---

## Optional: Enable Precisely DIS Services

Update the `extraEnv` section:

```yaml
extraEnv:
  DIS_URL: "https://api-dev.cloud.precisely.services"
  DIS_KEY: "<your-dis-key>"
  DIS_SECRET: "<your-dis-secret>"
```

---

# Step 5: Install Spatial Enrich Dashboard Helm Chart

Create namespace:

```shell
kubectl create namespace spatial-dashboard
```

Move to repository folder:

```shell
cd spatial-enrich-dashboard
```
Perform below steps : 

```shell
docker save spatial-enrich-dashboard:latest -o superset.tar
docker cp superset.tar desktop-control-plane:/superset.tar
docker exec desktop-control-plane ctr --namespace k8s.io images import /superset.tar
```

Install Helm chart:

```shell
helm install spatial-dashboard ./helm/superset \
-f ./helm/superset/values.yaml \
-n spatial-dashboard \
--wait
```

---

# Step 7: Verify Deployment

Check pods:

```shell
kubectl get pods -n spatial-dashboard
```

Expected:

```shell
NAME                                             READY   STATUS
spatial-dashboard-xxxxxxxxxx                     1/1     Running
spatial-dashboard-worker-xxxxxxxxxx              1/1     Running
spatial-dashboard-postgresql-0                   1/1     Running
spatial-dashboard-redis-master-0                 1/1     Running
```

Check services:

```shell
kubectl get svc -n spatial-dashboard
```

---

# Step 8: Access the Dashboard

Use port forwarding:

```shell
kubectl port-forward svc/spatial-dashboard 8088:80 -n spatial-dashboard
```

Open browser:

```text
http://localhost:8088
```

Default credentials:

```text
Username: admin
Password: admin
```

---

# Step 9: Troubleshooting

## Check pod status

```shell
kubectl get pods -n spatial-dashboard
```

---

## View pod logs

```shell
kubectl logs <pod-name> -n spatial-dashboard
```

Example:

```shell
kubectl logs spatial-dashboard-init-db-xxxxx -n spatial-dashboard
```

---

## Describe pod

```shell
kubectl describe pod <pod-name> -n spatial-dashboard
```

---

## Open shell inside pod

```shell
kubectl exec -it <pod-name> -n spatial-dashboard -- bash
```

---

## Restart deployment

```shell
kubectl rollout restart deployment spatial-dashboard -n spatial-dashboard
```

---

## Remove deployment

```shell
helm uninstall spatial-dashboard -n spatial-dashboard
```

Delete namespace:

```shell
kubectl delete namespace spatial-dashboard
```

---
