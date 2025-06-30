# Installing the Spatial Enrich Dashboard Helm Chart on AWS EKS

### Before starting
Make sure you have an AWS account with following permissions:  
  - create IAM roles  
  - create IAM policies  
  - create EKS clusters (EC2 based)  
  - create EFS filesystem  
  
## Step 1: Prepare your environment
To deploy Spatial Enrich Dashboard application in AWS EKS, install the following client tools:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm3](https://helm.sh/docs/intro/install/)

##### Amazon Elastic Kubernetes Service (EKS)

- [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)


### Clone Spatial Enrich Dashboard helm charts & resources
```
git clone https://github.com/PreciselyData/spatial-enrich-dashboard.git
```

## Step 2: Create K8s Cluster (EKS)

You can create the EKS cluster or use an existing EKS cluster.

- If you DON'T have a EKS cluster, we have provided you with a
  sample [cluster installation script](../../../cluster-sample/create-eks-cluster.yaml). Run the following command from
  parent directory to create the cluster using the script:
    ```shell
    eksctl create cluster -f ./cluster-sample/create-eks-cluster.yaml
    ```
	
  > Note: This scripts uses default node types that may not exist in your specific region (like eu-west-3). Change them accordingly (`managedNodeGroups.instanceType`) if the node type is not available in your region. 

- If you already have an EKS cluster, make sure you have following addons or plugins related to it, installed on the
  cluster:
    ```yaml
    addons:
    - name: vpc-cni
    - name: coredns
    - name: kube-proxy
    - name: aws-efs-csi-driver
    ```
  Run the following command to install addons only:
    ```shell
    aws eks --region [aws-region] update-kubeconfig --name [cluster-name]
    
    eksctl create addon -f ./cluster-sample/create-eks-cluster.yaml
    ```
- Once you create EKS cluster, you can
  apply [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) so that the
  cluster can be scaled vertically as per requirements. We have provided a sample cluster autoscaler script. Please run
  the following command to create cluster autoscaler:
    ```shell
    kubectl apply -f ./cluster-sample/cluster-auto-scaler.yaml
    ```
- To enable [HorizontalPodAutoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/), the
  cluster also needs a [Metrics API Server](https://github.com/kubernetes-sigs/metrics-server) for capturing cluster
  metrics. Run the following command for installing Metrics API Server:
    ```shell
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    ```

> Note: You should run this command in your shell to connect to EKS cluster:  
> `` aws eks --region [aws-region] update-kubeconfig --name [cluster-name] ``  
> This will update your local copy of EKS cluster configuration. 

## Step 3: Download Spatial Enrich Dashboard Docker Images

The Spatial Enrich Dashboard docker images need to be present in the ECR. If you haven't pushed the required docker images to ECR, then you you need to create the ECR with the repository name spatial-enrich-dashboard and push the provided images to the ECR.

## Step 4: Installation of Spatial Enrich Dashboard Helm Chart

Create a namespace in the cluster for deploying the dashboard

```shell
kubectl create ns spatial-dashboard
```

Create a secret for pulling image from ECR repository  
```shell
kubectl create secret docker-registry regcred --docker-server=[account_id].dkr.ecr.[aws_region].amazonaws.com   --docker-username=AWS   --docker-password=$(aws ecr get-login-password --region [aws-region]) --namespace=spatial-dashboard
```
To install/upgrade the Spatial Enrich Dashboard helm chart, use the following command:

helm install spatial-dashboard ~/spatial-enrich-dashboard/helm/superset \
 -f ~/spatial-enrich-dashboard/helm/superset/values.yaml \
 --set "image.repository=[account_id].dkr.ecr.[aws_region].amazonaws.com/spatial-enrich-dashboard" \
 --set "image.tag=latest" \ 
 --set "imagePullSecrets[0].name=regcred" \  
 --namespace spatial-dashboard   
```
> Note: Dashboard and custom charts will be deleted in case of postgresql pod dies so make sure to export the dashboard after creation .

#### Mandatory Parameters
* ``image.repository``: The ACR repository for Spatial Enrich Dashboard docker image e.g. spatialregistry.azurecr.io
* ``image.tag``: The docker image tag value e.g. 1.2.0 or latest.
* ``imagePullSecrets``: The name of the secret holding Azure Container Registry (ACR)  credential information.

Once you run Spatial Enrich Dashboard helm install/upgrade command, it might take few minutes to get ready for the first time. You can run the following command to check the creation of pods. Please wait until all the pods are in running state:
```shell
kubectl get pods -w --namespace spatial-dashboard 
```

After all the pods in namespace 'spatial-dashboard' are in 'ready' status, launch dashboard in a browser with the URL `https://<your external ip>`, which can be found by running the command 

```
kubectl get svc -n spatial-dashboard
```
