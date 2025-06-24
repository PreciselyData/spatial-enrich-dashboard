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