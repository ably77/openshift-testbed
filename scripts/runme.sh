#!/bin/bash

source ./vars.txt
platform=$1

### Check if argocd CLI is installed
#ARGOCLI=$(which argocd)
#echo checking if argocd CLI is installed
#if [[ $ARGOCLI == "" ]]
#then
#        echo
#        echo "argocd CLI not installed"
#        echo "see https://github.com/argoproj/argo-cd/blob/master/docs/cli_installation.md for installation instructions"
#        echo "re-run the script after argocd CLI is installed"
#        echo
#        exit 1
#fi

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

### check kafka operator deployment status
echo waiting for kafka deployment to complete
./scripts/waitfor-pod -t 10 strimzi-cluster-operator-v0.19.0

### check grafana operator deployment status
echo checking grafana deployment status before deploying applications
./scripts/waitfor-pod -t 10 grafana-operator

### check codeready operator deployment status
echo checking grafana deployment status before deploying applications
./scripts/waitfor-pod -t 10 codeready-operator

### check openshift pipelines operator deployment status
echo checking grafana deployment status before deploying applications
./scripts/waitfor-pod -t 10 openshift-pipelines-operator

### check podium operator deployment status
echo checking grafana deployment status before deploying applications
./scripts/waitfor-pod -t 10 podium-operator

### check kafka deployment status
echo waiting for kafka deployment to complete
./scripts/waitfor-pod -t 20 my-cluster-kafka-2

### check grafana deployment status
echo checking grafana deployment status before deploying applications
./scripts/waitfor-pod -t 10 grafana-deployment

### check istio deployment status
echo checking istio deployment status before deploying applications
./scripts/wait-for-rollout.sh deployment istiod-basic istio-system 10

### check kiali deployment status
echo checking kiali deployment status before deploying applications
./scripts/wait-for-rollout.sh deployment kiali istio-system 10

### deploy frontend apps in argocd
echo deploying frontend apps
oc apply -k https://github.com/${GITHUB_USERNAME}/openshift-testbed-apps/argo-apps/dev/${platform}/meta

### wait for IoT Demo
./scripts/waitfor-pod -t 10 consumer-app

### wait for codeready workspace to deploy
./scripts/wait-for-rollout.sh deployment codeready codeready 20

### end
echo
echo installation complete

