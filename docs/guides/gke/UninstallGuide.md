[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)

# Uninstall Guide for GKE

To uninstall the Spatial Enrich Dashboard helm chart, run the following command:

```shell
## set the release-name & namespace (must be same as previously installed)
export RELEASE_NAME="spatial-dashboard"
export RELEASE_NAMESPACE="spatial-dashboard"

## uninstall the chart
helm uninstall \
  "$RELEASE_NAME" \
  --namespace "$RELEASE_NAMESPACE"
```