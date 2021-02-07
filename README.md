# Fast Cluster

This tool creates a kubernetes cluster with k3d. The default cluster contains:

- Helm Operator and CRD for Helm Releases.
- Sample Chart Museum server.
- Sample Artifactory Server.

## Requirements

- Docker
- `k3d`
- Helm (versión 3)
- `kubectl`

## Instructions

Create the cluster:

1. Adjust your `.env` file.
2. Add your kubernetes files (requires `kustomize`).
3. Run `./start-cluster.sh` and wait for your cluster.
4. Run `export KUBECONFIG=$HOME/.config/k3d/$CLUSTER_NAME/kubeconfig.yaml` to get the cluster context, or you can use `kubectx` as well.

Stop and remove the cluster:

1. Run `./kill-cluster.sh`
