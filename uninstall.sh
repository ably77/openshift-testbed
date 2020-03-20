#!/bin/bash

### Check if argocd CLI is installed
ARGOCLI=$(which argocd)
echo checking if argocd CLI is installed
if [[ $ARGOCLI == "" ]]
then
        echo
        echo "argocd CLI not installed"
        echo "see https://github.com/argoproj/argo-cd/blob/master/docs/cli_installation.md for installation instructions"
        echo "re-run the script after argocd CLI is installed"
        echo
        exit 1
fi

# Removing Argo/IoT demo from dr cluster (if it exists)
./multi-cluster/dr/dr_uninstall.sh

# Removing Argo/IoT demo from eu cluster (if it exists)
./multi-cluster/eu/eu_uninstall.sh

# Removing Argo/IoT demo from azure cluster (if it exists)
./multi-cluster/azure/azure_uninstall.sh

# Removing Argo/IoT demo from azure cluster (if it exists)
./multi-cluster/gcp/gcp_uninstall.sh

# Removing Argo/IoT demo from main cluster (if it exists)
./argocd/uninstall.sh

# delete CRDs
oc delete -f crds/

# Delete argocd project
oc delete project argocd

# Switch to default project
oc project default
