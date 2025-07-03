# Installing the Spatial Enrich Dashboard Helm Chart on Google Cloud GKE

### Before starting
Make sure you have a Google Cloud account with following permissions:  
- A project that IAM has roles of Kubernetes Engine Admin (roles/container.admin or roles/owner) and Artifact Registry Writer (roles/artifactregistry.writer)
- Cloud Shell
  
## Step 1: Setup Cloud Shell
Login to Google Cloud Console

Ensure you are in the right project

Open Cloud Shell by clicking on the icon on the tool bar

Verify the following utilities,

```
gcloud -h
```
```
kubectl -h
```
```
helm -h
```

### Clone Spatial Enrich Dashboard helm charts & resources
```
git clone https://github.com/PreciselyData/spatial-enrich-dashboard.git
```

## Step 2: Create K8s Cluster (GKE)

Also see Google Cloud Document https://cloud.google.com/kubernetes-engine?hl=en

> NOTE: a GKE Autopilot cluster is used in this doc. A Standard mode cluster can also be used but it has extra steps required that are not covered here.

### Create GKE cluster

Set up the project and region to use, e.g. my-project, us-east1
```
gcloud config set compute/region us-east1
```
The project should be set automatically, but you can update it if needed,
```
gcloud config set project <my-project>
```
Check the settings,
```
gcloud config list
```

Create GKE cluster (autopilot) named spatial-cloud-native. You can specify different project and region with `--project` and `--region`.
```
gcloud container clusters create-auto spatial-dashboard --region us-east1 --cluster-version 1.33
```
It may take few minutes to create the cluster. Wait until the command finished.
```
kubectl get nodes
```
You may see no resources at beginning as no pods deployed yet.
```
No resources found
```
> NOTE: if the cluster version was not found, using the following command to list all valid cluster versions. Looking for one under REGULAR channel.
```
gcloud container get-server-config
```

## Step 3: Download Spatial Enrich Dashboard Docker Images

AWS Artifact Repository is used to hold the docker images and deploy from it.

### Create Artifact registry

Run the command with your region,
```
gcloud artifacts repositories create spatial-repo \
    --repository-format=docker \
    --location=<your region> \
    --description="Docker repository"
```

Find out 'Registry URL',
```
gcloud artifacts repositories describe spatial-repo --location=<your region>
```

### Load images to artifact registry

Run the shell scripts to load images to artifact registry,

> Note: Place the provided spatial-enrich-dashboard.tar file to this newly created directly <spatial_enrich_dashboard_docker_images_dir>.
```
cd <spatial_enrich_dashboard_docker_images_dir>
chmod a+x ~/spatial-enrich-dashboard/scripts/gke/push-images.sh
```
> Note: Make sure to adjust the spatial-enrich-dashboard path with respect to <spatial_enrich_dashboard_docker_images_dir>.

```
~/spatial-enrich-dashboard/scripts/gke/push-images.sh <your registry url>
```

List images in the artifact registry
```
gcloud artifacts docker images list <your registry url>
```

Once you finished the testing, if you do not want this artifact registry anymore, you can delete it for cost saving,
```
gcloud artifacts repositories delete spatial-repo --location=<your region>
```

## Step 4: Installation of Spatial Enrich Dashboard Helm Chart


### Deploy Spatial Enrich Dashboard


```
helm install spatial-dashboard ~/spatial-enrich-dashboard/helm/superset \
 -f ~/spatial-enrich-dashboard/helm/superset/values.yaml \
 --set "image.repository=<your registry url followed by repo name> \
 --set "image.tag=latest" \ 
 --set "imagePullSecrets=null" \  
```
> Note: Make sure to adjust the spatial-enrich-dashboard path with respect to your setup.

> Note: Dashboard and custom charts will be deleted in case of postgresql pod dies so make sure to export the dashboard after creation.

Wait until all services are ready. It may take 5 to 8 minutes to get ready for the first time. 
```
kubectl get pod 
```

After all the pods in namespace 'spatial-dashboard' are in 'ready' status, launch dashboard in a browser with the URL `http://<your external ip>`, which can be found by running the command 

```
kubectl get svc -n spatial-dashboard
```
> Note: If the application does not load on the http protocol try with https as well.