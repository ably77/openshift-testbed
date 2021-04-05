#!/bin/bash

source ./vars.txt
platform=$1

if [ $# -eq 0 ]; then
    echo "No arguments provided. Please provide platform:"
    echo "Examples:"
    echo "./scripts/runme.sh aws"
    echo "./scripts/runme.sh azure"
    echo "./scripts/runme.sh gcp"
    echo "./scripts/runme.sh vsphere"
    exit 1
fi

# create argocd operator
echo now deploying argoCD
until oc apply -k https://github.com/${GITHUB_USERNAME}/openshift-testbed-apps/kustomize/instances/overlays/operators/namespaced-operators/argocd-operator; do sleep 2; done

# wait for argo cluster rollout
./scripts/wait-for-rollout.sh deployment argocd-server argocd 10

# label node for jitsi video
random_node1=$(oc get nodes | grep worker | awk 'NR==1{ print $1 }')
random_node2=$(oc get nodes | grep worker | awk 'NR==2{ print $1 }')
oc label node $random_node1 app=jvb
oc label node $random_node2 app=jvb

### deploy cluster-config in argocd
echo deploying cluster-config
oc apply -k https://github.com/${GITHUB_USERNAME}/openshift-testbed-apps/argo-apps/cluster-config

### deploy operators in argocd
echo deploying operators
oc apply -k https://github.com/${GITHUB_USERNAME}/openshift-testbed-apps/argo-apps/operators/meta

### check kafka deployment status
echo waiting for kafka deployment to complete
./scripts/waitfor-pod -t 20 my-cluster-kafka-2

### deploy frontend apps in argocd
echo deploying frontend apps
oc apply -k https://github.com/${GITHUB_USERNAME}/openshift-testbed-apps/argo-apps/dev/${platform}/meta

### wait for codeready workspace to deploy
./scripts/wait-for-rollout.sh deployment codeready codeready 20

### end
echo
echo installation complete
echo to open demo routes run the script ./scripts/open-routes.sh

