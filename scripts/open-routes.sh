#!/bin/bash

source ./vars.txt

### Open argocd route
argocd_route=$(oc get routes --all-namespaces | grep argocd-server-argocd.apps. | awk '{ print $3 }')
open http://${argocd_route}

### open grafana route
echo opening grafana route
grafana_route=$(oc get routes --all-namespaces | grep grafana-route-grafana.apps | awk '{ print $3 }')
open https://${grafana_route}

### open IoT demo app route
echo opening consumer-app route
iot_route=$(oc get routes --all-namespaces | grep consumer-app-iotdemo-app.apps | awk '{ print $3 }')
open http://${iot_route}

### create/open codeready workspace from custom URL dev-file.yaml
echo deploying codeready workspace
CHE_HOST=$(oc get routes --all-namespaces | grep codeready-codeready.apps | awk '{ print $3 }')
open http://${CHE_HOST}/f?url=${CODEREADY_DEVFILE_URL}

### open Podium route
echo opening podium route
podium_route=$(oc get routes --all-namespaces | grep podium-podium.apps | awk '{ print $3 }')
open http://${podium_route}

### open Kiali route
echo opening kiali route
kiali_route=$(oc get routes --all-namespaces | grep kiali-istio-system.apps | awk '{ print $3 }')
open http://${kiali_route}

### open Book Info route
echo opening book info route
istio_gateway=$(oc -n istio-system get route istio-ingressgateway -o jsonpath='{.spec.host}')
open http://${istio_gateway}/productpage

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
echo podium collaboration dashboard
echo http://${podium_route}
echo
echo codeready workspaces: create a new user to initiate workspace build
echo http://${CHE_HOST}/f?url=${CODEREADY_DEVFILE_URL}
echo