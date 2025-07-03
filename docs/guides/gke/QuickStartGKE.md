# Installing the Spatial Enrich Dashboard Helm Chart on Google Cloud GKE

## 📌 Prerequisites

Ensure you have a Google Cloud account with the following:

- A GCP Project where you have:
  - `Kubernetes Engine Admin` (`roles/container.admin` or `roles/owner`)
  - `Artifact Registry Writer` (`roles/artifactregistry.writer`)
- Cloud Shell access

---

## 🧰 Step 1: Setup Cloud Shell

1. Log in to [Google Cloud Console](https://console.cloud.google.com)
2. Ensure you're in the correct project.
3. Open **Cloud Shell** by clicking the terminal icon in the top right.
4. Validate required utilities are installed:

```bash
gcloud -h
kubectl -h
helm -h
```

### ✅ Clone Spatial Enrich Dashboard Helm Charts & Resources

```bash
git clone https://github.com/PreciselyData/spatial-enrich-dashboard.git
```

---

## ☸️ Step 2: Create Kubernetes Cluster (GKE)

📘 Refer: [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine?hl=en)

> **Note**: This guide uses a **GKE Autopilot** cluster. Standard mode is also supported but has additional steps not covered here.

### 🔧 Configure Region and Project

```bash
gcloud config set compute/region us-east1
gcloud config set project <my-project>
gcloud config list
```

### 🚀 Create GKE Autopilot Cluster

```bash
gcloud container clusters create-auto spatial-dashboard   --region us-east1   --cluster-version 1.33
```

Wait for the cluster creation to complete.

### 🔍 Verify Cluster

```bash
kubectl get nodes
# May return "No resources found" initially.
```

> 💡 If the specified cluster version isn't available, list valid versions using:
```bash
gcloud container get-server-config
```

---

## 🐳 Step 3: Download and Push Docker Images to Artifact Registry

> Spatial Enrich Dashboard images are stored and deployed from Google Artifact Registry.

### 🏗️ Create Artifact Registry

```bash
gcloud artifacts repositories create spatial-repo     --repository-format=docker     --location=<your-region>     --description="Docker repository"
```

### 🔗 Get Registry URL

```bash
gcloud artifacts repositories describe spatial-repo     --location=<your-region>
```

### 📦 Push Docker Images

1. Place the `spatial-enrich-dashboard.tar` file inside `<spatial_enrich_dashboard_docker_images_dir>`.
2. Run the push script:

```bash
cd <spatial_enrich_dashboard_docker_images_dir>
chmod a+x ~/spatial-enrich-dashboard/scripts/gke/push-images.sh
~/spatial-enrich-dashboard/scripts/gke/push-images.sh <your-registry-url>
```

> ⚠️ Ensure correct path is used for the script relative to your current directory.

### 📋 List Uploaded Images

```bash
gcloud artifacts docker images list <your-registry-url>
```

### 🧹 Optional: Delete Registry (for cost-saving)

```bash
gcloud artifacts repositories delete spatial-repo --location=<your-region>
```

---

## 📈 Step 4: Install Spatial Enrich Dashboard via Helm

### 🛠️ Deploy Helm Chart

```bash
helm install spatial-dashboard ~/spatial-enrich-dashboard/helm/superset   -f ~/spatial-enrich-dashboard/helm/superset/values.yaml   --set "image.repository=<your-registry-url/repo-name>"   --set "image.tag=latest"   --set "imagePullSecrets=null"
```

> 🔁 Adjust paths and registry values based on your setup.

> ⚠️ Important: Dashboards and charts may be deleted if PostgreSQL pod crashes. **Export your dashboards after creation.**

---

## 🌐 Accessing the Dashboard

Wait 5–8 minutes for services to initialize.

### 🔍 Get External IP

```bash
EXTERNAL_IP=$(kubectl get svc spatial-dashboard -n spatial-dashboard -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Access the dashboard at: http://$EXTERNAL_IP or https://$EXTERNAL_IP"
```

OR

```bash
kubectl get pods -w --namespace spatial-dashboard
```

Sample Output:

```bash
NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
spatial-dashboard    LoadBalancer   10.100.87.118   10.105.97.145   80:30080/TCP   5m
```

Once all pods are in the `Ready` state, open the dashboard at:

```
https://<your-external-ip>
```

> 🔁 If `http://` does not work, try `https://`.

---