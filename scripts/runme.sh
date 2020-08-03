#!/bin/bash

source ./vars.txt

# run argocd install script
./argocd/runme.sh

# label node for jitsi video
random_node1=$(oc get nodes | grep worker | awk 'NR==1{ print $1 }')
random_node2=$(oc get nodes | grep worker | awk 'NR==2{ print $1 }')
oc label node $random_node1 app=jvb
oc label node $random_node2 app=jvb

### deploy operators in argocd
echo deploying operators
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/argocd/apps/meta/meta-operators.yaml

### check kafka operator deployment status
echo waiting for kafka deployment to complete
./extras/waitfor-pod -t 10 strimzi-cluster-operator-v0.18.0

### check grafana operator deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 grafana-operator

### check codeready operator deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 codeready-operator

### check openshift pipelines operator deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 openshift-pipelines-operator

### check podium operator deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 podium-operator

### deploy backend services in argocd
echo deploying backend app services
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/argocd/apps/meta/meta-backend-apps.yaml

### check kafka deployment status
echo waiting for kafka deployment to complete
./extras/waitfor-pod -t 20 my-cluster-kafka-2

### check grafana deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 grafana-deployment

### deploy frontend apps in argocd
echo deploying frontend apps
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/argocd/apps/meta/meta-dev-apps.yaml

### Wait for IoT Demo
./extras/waitfor-pod -t 10 consumer-app

### switch to codeready namespace
oc project codeready

### wait for codeready workspace to deploy
./extras/wait-for-rollout.sh deployment codeready codeready

### end
echo
echo installation complete

