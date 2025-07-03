# 🚀 Deploying the Spatial Enrich Dashboard on AWS EKS

This guide walks you through setting up and deploying the **Spatial Enrich Dashboard** using **Helm Charts** on **Amazon Elastic Kubernetes Service (EKS)**.

---

## ✅ Prerequisites

Ensure you have the following:

### AWS Account Permissions

- Create IAM roles  
- Create IAM policies  
- Create EC2-based EKS clusters  

### Local Tools

Install the following tools:

| Tool       | Description                                | Link |
|------------|--------------------------------------------|------|
| `kubectl`  | Kubernetes CLI                              | [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) |
| `helm`     | Helm v3+ (Kubernetes package manager)       | [Install Helm](https://helm.sh/docs/intro/install/) |
| `aws-cli`  | AWS CLI                                     | [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) |
| `eksctl`   | CLI for managing EKS clusters               | [Install eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) |

---

## 📁 Step 1: Clone the Helm Charts

Clone the Spatial Enrich Dashboard Helm charts and resource files:

```bash
git clone https://github.com/PreciselyData/spatial-enrich-dashboard.git
```

---

## 🛠️ Step 2: Create or Connect to an EKS Cluster

### 🔨 Option A: Create a New EKS Cluster

Run the following command from the parent directory using the provided YAML config:

```bash
eksctl create cluster -f ~/spatial-enrich-dashboard/cluster-sample/create-eks-cluster.yaml
```

> ⚠️ *Update the `instanceType` in the YAML if your selected region does not support the default one (e.g. `us-east-1`).*

---

### 🔗 Option B: Use an Existing EKS Cluster

Ensure the following addons are installed:

```yaml
addons:
  - name: vpc-cni
  - name: coredns
  - name: kube-proxy
  - name: aws-efs-csi-driver
```

Update kubeconfig and apply addons:

```bash
aws eks --region <aws-region> update-kubeconfig --name <cluster-name>
eksctl create addon -f ./cluster-sample/create-eks-cluster.yaml
```

---

### ⚙️ (Optional) Enable Autoscaling

**Vertical Cluster Autoscaler:**

```bash
kubectl apply -f ./cluster-sample/cluster-auto-scaler.yaml
```

**Horizontal Pod Autoscaler:**

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

> 💡 Always run this to update kubeconfig:
> 
> ```bash
> aws eks --region <region> update-kubeconfig --name <cluster-name>
> ```

---

## 📦 Step 3: Prepare Docker Images for Deployment

The Spatial Enrich Dashboard images must be pushed to your **Amazon ECR** registry.

---

### 🧰 Prerequisites

- Docker installed and running
- AWS CLI configured (`aws configure`)
- IAM permissions to access ECR
- ECR repository named `spatial-enrich-dashboard` created

---

### 🔐 1. Authenticate Docker to ECR

```bash
aws ecr get-login-password --region <region>   | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
```

Replace:
- `<region>`: Your AWS region (e.g., `us-east-1`)
- `<account_id>`: Your AWS 12-digit account ID

---

### 🏗️ 2. Create ECR Repository (If Needed)

```bash
aws ecr create-repository --repository-name spatial-enrich-dashboard --region <region>
```

---

### 📤 3. Push Docker Image to ECR

Ensure the `.tar` image file exists at <spatial_enrich_dashboard_docker_images_dir>:

```bash
cd <spatial_enrich_dashboard_docker_images_dir>
chmod a+x ~/spatial-enrich-dashboard/scripts/eks/push-images.sh
~/spatial-enrich-dashboard/scripts/eks/push-images.sh <account_id>.dkr.ecr.<region>.amazonaws.com
```

> 📝 Replace `<spatial_enrich_dashboard_docker_images_dir>` with the directory path containing `spatial-enrich-dashboard.tar`.

To verify:

```bash
aws ecr describe-images --repository-name spatial-enrich-dashboard --region <region>
```

---

## 📊 Step 4: Install the Helm Chart

### 1️⃣ Create Kubernetes Namespace

```bash
kubectl create namespace spatial-dashboard
```

---

### 2️⃣ Create Secret for ECR Image Pull

```bash
kubectl create secret docker-registry regcred   --docker-server=<account_id>.dkr.ecr.<region>.amazonaws.com   --docker-username=AWS   --docker-password=$(aws ecr get-login-password --region <region>)   --namespace=spatial-dashboard
```

---

### 3️⃣ Install via Helm

```bash
helm install spatial-dashboard ~/spatial-enrich-dashboard/helm/superset   -f ~/spatial-enrich-dashboard/helm/superset/values.yaml   --set "image.repository=<account_id>.dkr.ecr.<region>.amazonaws.com/spatial-enrich-dashboard"   --set "image.tag=latest"   --set "imagePullSecrets[0].name=regcred"   --namespace spatial-dashboard
```

> ⚠️ *Adjust the path to the chart files as needed.*  
> ❗ Dashboards and custom charts will be **lost** if the PostgreSQL pod is deleted. **Export your dashboards regularly.**

---

### 📌 Helm Chart Parameters

| Parameter            | Description                                                  |
|----------------------|--------------------------------------------------------------|
| `image.repository`   | Docker image repo URL in ECR (e.g., `<account>.dkr.ecr...`)  |
| `image.tag`          | Docker image tag to use (e.g., `latest` or `1.2.0`)          |
| `imagePullSecrets`   | Kubernetes secret name for image pulling (`regcred`)         |

---

## 🌐 Step 5: Access the Dashboard

### 🔍 Check Pod Status

```bash
kubectl get pods -w --namespace spatial-dashboard
```

---

### 🌐 Get External IP

```bash
EXTERNAL_IP=$(kubectl get svc spatial-dashboard -n spatial-dashboard -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Access the dashboard at: http://$EXTERNAL_IP or https://$EXTERNAL_IP"
```

Sample output:

```bash
NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP                     PORT(S)        AGE
spatial-dashboard    LoadBalancer   10.100.87.118   a1b2c3d4.elb.amazonaws.com      80:30080/TCP   5m
```

---

### ✅ Final Step

Open your browser and go to:

```text
https://<your-external-ip>
```

> 🧠 Tip: If the dashboard doesn’t load on `http`, try `https`.  
> If no external IP appears:
> - Make sure your cluster supports LoadBalancer services (like AWS ELB)
> - Ensure the security group allows inbound traffic on **port 80/443**

---
