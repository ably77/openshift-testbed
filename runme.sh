#!/bin/bash

# Codeready Parameters
CODEREADY_DEVFILE_URL="https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/codeready-workspaces/dev-file/openshift-testbed-dev-file.yaml"

#### Create artemis CRDs
oc create -f extras/crds/

# run argocd install script
./argocd/runme.sh

# label node for jitsi video
random_node1=$(oc get nodes | grep worker | awk 'NR==1{ print $1 }')
random_node2=$(oc get nodes | grep worker | awk 'NR==2{ print $1 }')
oc label node $random_node1 app=jvb
oc label node $random_node2 app=jvb

### deploy shared components in argocd
echo deploying shared components
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/argocd/apps/meta/meta-shared.yaml
sleep 5

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

### open grafana route
echo opening grafana route
grafana_route=$(oc get routes --all-namespaces | grep grafana-route-grafana.apps | awk '{ print $3 }')
open https://${grafana_route}

### deploy frontend apps in argocd
echo deploying frontend apps
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/argocd/apps/meta/meta-frontend-apps.yaml

### Wait for IoT Demo
./extras/waitfor-pod -t 10 consumer-app

### open IoT demo app route
echo opening consumer-app route
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

### open manuELA IoT dashboard route
echo opening manuELA IoT dashboard route
manuela_route=$(oc get routes --all-namespaces | grep line-dashboard-manuela- | awk '{ print $3 }')
open http://${manuela_route}

### open Podium route
echo opening podium route
podium_route=$(oc get routes --all-namespaces | grep podium-podium.apps | awk '{ print $3 }')
open http://${podium_route}

### end
echo
echo installation complete
echo
echo
echo links to relevant demo routes:
echo
echo temperature sensors iot demo dashboard:
echo http://${iot_route}
echo
echo grafana dashboards:
echo https://${grafana_route}
echo
echo argocd console:
echo http://${argocd_route}
echo
echo manuELA IoT dashboard:
echo http://${manuela_route}
echo
echo podium collaboration dashboard
echo http://${podium_route}
echo
echo codeready workspaces: create a new user to initiate workspace build
echo http://${CHE_HOST}/f?url=${CODEREADY_DEVFILE_URL}
echo
