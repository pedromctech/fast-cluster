#!/bin/bash

export $(egrep -v '^#' .env | xargs)

export KUBECONFIG=$HOME/.config/k3d/$CLUSTER_NAME/kubeconfig.yaml

k3d stop --name $CLUSTER_NAME
k3d delete --name $CLUSTER_NAME
rm -rf ~/.config/k3d/$CLUSTER_NAME
