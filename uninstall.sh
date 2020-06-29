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
#./multi-cluster/dr/dr_uninstall.sh

# Removing Argo/IoT demo from eu cluster (if it exists)
#./multi-cluster/eu/eu_uninstall.sh

# Removing Argo/IoT demo from azure cluster (if it exists)
#./multi-cluster/azure/azure_uninstall.sh

# Removing Argo/IoT demo from azure cluster (if it exists)
#./multi-cluster/gcp/gcp_uninstall.sh

# delete argo apps
oc delete -f argocd/apps/2/
oc delete -f argocd/apps/1/
oc delete -f argocd/apps/testing/

# Wait for app deletion
./extras/wait-for-argo-app-deletion.sh

# delete argocd
oc delete -f argocd/argocd_operator.yaml

# delete CRDs
oc delete -f crds/

# delete CSVs
oc delete csv -n openshift-operators --all

# Delete argocd project
oc delete project argocd

# Switch to default project
oc project default
