#!/bin/bash

# create namespace
oc create -f projects.yml

# use namespace
oc project basic-spring-boot-build

# Process build and deployment pipelines
oc process -f build.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SOURCE_REPOSITORY_URL="https://github.com/ably77/container-pipelines.git" -p APPLICATION_SOURCE_REPO="https://github.com/ably77/spring-rest.git" | oc apply -f-

oc process -f deployment.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SA_NAMESPACE=basic-spring-boot-build -p READINESS_PATH="/health" -p READINESS_RESPONSE="status.:.UP" | oc apply -f-

# Deploy build pipeline
tkn -n basic-spring-boot-build pipeline start basic-spring-boot-pipeline -r basic-spring-boot-git=basic-spring-boot-git -s tekton
