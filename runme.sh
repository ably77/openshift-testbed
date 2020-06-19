#!/bin/bash

# Codeready Parameters
CODEREADY_DEVFILE_URL="https://raw.githubusercontent.com/ably77/openshift-testbed-argo-codeready/master/dev-file/strimzi-demo-devfile.yaml"

#### Create demo CRDs
oc create -f crds/

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

### deploy ArgoCD
./argocd/runme.sh

### Open argocd route
argocd_route=$(oc get routes --all-namespaces | grep argocd-server-argocd.apps. | awk '{ print $3 }')
open http://${argocd_route}

echo sleeping 10 seconds before deploying argo apps
sleep 10

# label node for jitsi video (podium - hacky fix this later)
random_node1=$(oc get nodes | grep worker | awk 'NR==1{ print $1 }')
random_node2=$(oc get nodes | grep worker | awk 'NR==2{ print $1 }')
oc label node $random_node1 app=jvb
oc label node $random_node2 app=jvb

### deploy apps in argocd
echo deploying prometheus, kafka, grafana, and codeready applications in argocd
oc create -f argocd/apps/1/

### check kafka deployment status
echo waiting for kafka deployment to complete
./extras/waitfor-pod -t 20 my-cluster-kafka-2

### check grafana deployment status
echo checking grafana deployment status before deploying applications
./extras/waitfor-pod -t 10 grafana-deployment

### deploy IoT demo and strimzi-loadtest application in argocd
echo creating iot-demo and strimzi-loadtest apps in argocd
oc create -f argocd/apps/2/

### open grafana route
echo opening grafana route
grafana_route=$(oc get routes --all-namespaces | grep grafana-route-myproject.apps | awk '{ print $3 }')
open https://${grafana_route}

### Wait for IoT Demo
./extras/waitfor-pod -t 10 consumer-app

### open IoT demo app route
echo opening consumer-app route
# fix this static address
iot_route=$(oc get routes --all-namespaces | grep consumer-app-iotdemo-app.apps | awk '{ print $3 }')
open http://${iot_route}

### switch to codeready namespace
oc project codeready

### wait for codeready workspace to deploy
./extras/wait-for-rollout.sh deployment codeready codeready

### create/open codeready workspace from custom URL dev-file.yaml
echo deploying codeready workspace
CHE_HOST=$(oc get routes --all-namespaces | grep codeready-codeready.apps | awk '{ print $3 }')
open http://${CHE_HOST}/f?url=${CODEREADY_DEVFILE_URL}

### end
echo
echo installation complete
echo
echo
echo links to console routes:
echo
echo iot demo console:
echo http://${iot_route}
echo
echo grafana dashboards:
echo https://${grafana_route}
echo
echo argocd console:
echo argocd login: admin/secret
echo http://${argocd_route}
echo
echo codeready workspaces: create a new user to initiate workspace build
echo http://${CHE_HOST}/f?url=${CODEREADY_DEVFILE_URL}
echo
