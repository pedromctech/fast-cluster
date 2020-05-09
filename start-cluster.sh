#!/bin/bash

export $(egrep -v '^#' .env | xargs)

wait_command() {
  NOT_READY=true
  while [ $NOT_READY = true ]; do
    sleep 2
    eval "$1"
    if [ $? -eq 0 ]; then
      echo "Ready"
      NOT_READY=false
    fi
  done
}

# Remove previous damaged cluster
./kill-cluster.sh

# Create the new one
export KUBECONFIG=$HOME/.config/k3d/$CLUSTER_NAME/kubeconfig.yaml
k3d create --name $CLUSTER_NAME --workers $WORKERS

# Wait for cluster ready
wait_command "k3d get-kubeconfig --name='$CLUSTER_NAME'"


# Add Helm repos
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add fluxcd https://charts.fluxcd.io
helm repo update


# Install Helm Release CRD
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/1.0.1/deploy/crds.yaml

# Install Helm Operator
kubectl create ns flux
helm upgrade -i helm-operator fluxcd/helm-operator \
  --namespace flux \
  --set helm.versions=v3

# Install kubernetes files
if [[ $KUBERNETES_FILES = 'true' ]]; then
  kubectl apply -k kubernetes-files/.
fi
