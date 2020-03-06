#!/bin/bash

# create namespace
oc create -f projects.yml

# use namespace
oc project basic-spring-boot-build

# Process and create build and deployment pipelines

# test if you need the static links
#oc process -f build.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SOURCE_REPOSITORY_URL="https://github.com/redhat-cop/container-pipelines" -p APPLICATION_SOURCE_REPO="https://github.com/redhat-cop/spring-rest" | oc apply -f-
oc process -f build.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build | oc apply -f-

oc process -f deployment.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SA_NAMESPACE=basic-spring-boot-build -p READINESS_PATH="/health" -p READINESS_RESPONSE="status.:.UP" | oc apply -f-

### setup triggers
oc create -f triggers/

### setup github webhook
./github-webhooks/runme.sh

### list pipeline
tkn pipeline list

### follow logs
echo to follow logs:
echo "tkn pipeline logs -f"

### empty commit
echo to create an empty commit:
echo "git commit -m "empty-commit" --allow-empty && git push origin master"
