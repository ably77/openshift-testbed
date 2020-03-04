#!/bin/bash

# create argocd build pipeline
oc create -f springboot-tekton-argo.yaml

# sleep 15 seconds for namespace creation
echo sleeping 15 seconds for namespace creation
sleep 15

# create basic-spring-boot-build deployment
oc process -f deployment.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SA_NAMESPACE=basic-spring-boot-build -p READINESS_PATH="/health" -p READINESS_RESPONSE="status.:.UP" | oc apply -f-
