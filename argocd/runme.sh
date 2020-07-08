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

echo now deploying argoCD

# create argocd operator
oc create -f argocd/deploy/argocd-operator.yaml

# wait for operator deployment
./extras/waitfor-pod -n argocd -t 10 argocd-operator

# create argocd cluster
oc create -f argocd/deploy/argocd-cluster.yaml

# wait for cluster deployment
./extras/waitfor-pod -n argocd -t 10 argocd-application-controller

# sleep for 45 seconds
echo "sleeping for 45 seconds for argocd to finish installing"
sleep 45

# Add argocd main project
oc create -f argocd/deploy/main-project.yaml

# add argocd repos
./argocd/deploy/add_repos.sh

### Open argocd route
argocd_route=$(oc get routes --all-namespaces | grep argocd-server-argocd.apps. | awk '{ print $3 }')
open http://${argocd_route}