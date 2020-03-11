#!/bin/bash

echo
echo To run this demo we will need some variables
echo "- CLUSTER_NAME "
echo "- CLUSTER_DOMAIN"
echo "- GITHUB_USERNAME"
echo "- GITHUB_ORG (same as username if no org exists)"
echo "- GITHUB_TOKEN (https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)"
echo

read -p 'Cluster Name: ' CLUSTER_NAME
echo $CLUSTER_NAME

read -p 'Cluster Domain: ' CLUSTER_DOMAIN
echo $CLUSTER_DOMAIN

read -p 'Github Username: ' GITHUB_USERNAME
echo $GITHUB_USERNAME

read -p 'Github Org: ' GITHUB_ORG
echo $GITHUB_ORG

read -p 'Github Token: ' GITHUB_TOKEN
echo $GITHUB_TOKEN

### Generate Github Webhook Secret
sed -e "s/<GITHUB_TOKEN>/${GITHUB_TOKEN}/g" templates/webhook-secret.yaml.template > github-webhooks/wh-webhook-secret.yaml

### Generate Github Webhook TaskRun
sed -e "s/<GITHUB_ORG>/${GITHUB_ORG}/g" -e "s/<GITHUB_USERNAME>/${GITHUB_USERNAME}/g" -e "s/<CLUSTER_NAME>/${CLUSTER_NAME}/g" -e "s/<CLUSTER_DOMAIN>/${CLUSTER_DOMAIN}/g" templates/webhook-taskrun.yaml.template > github-webhooks/wh-create-spring-repo-webhook-run.yaml

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
