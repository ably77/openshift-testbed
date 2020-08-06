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
oc apply -k argocd/deploy/operator/

# wait for operator deployment
./scripts/waitfor-pod -n argocd -t 10 argocd-operator

# create argocd cluster
oc apply -k argocd/deploy/cr

# wait for argo cluster rollout
./scripts/wait-for-rollout.sh deployment argocd-server argocd 10