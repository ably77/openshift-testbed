#!/bin/bash

echo
echo To run this demo we will need some variables
echo "- CLUSTER_NAME "
echo "- CLUSTER_DOMAIN"
echo "- GITHUB_USERNAME"
echo "- GITHUB_ORG (same as username if no org exists)"
echo "- GITHUB_TOKEN (https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)"
echo "     Permissions Required for Token:"
echo "     - public_repo"
echo "     - admin: repo_hook"
echo

### Display cluster URL
echo "Displaying cluster URL for convenience:"
oc cluster-info | awk 'NR==1{ print $6 }'
echo "Cluster URL should follow this convention: https://api.<CLUSTER_NAME>.<CLUSTER_DOMAIN>:6443"
echo

echo "Input the following variables:"
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
oc process -f build.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build | oc apply -f-

oc process -f deployment.yml -p APPLICATION_NAME=basic-spring-boot -p NAMESPACE=basic-spring-boot-build -p SA_NAMESPACE=basic-spring-boot-build -p READINESS_PATH="/health" -p READINESS_RESPONSE="status.:.UP" | oc apply -f-

### setup triggers
echo
echo setting up webhook trigger
oc create -f triggers/

### setup github webhook
echo
echo setting up github webhook
./github-webhooks/runme.sh

### list pipeline
echo
echo "listing pipeline with command: tkn pipeline list"
tkn pipeline list

### next steps
echo
echo "Fork this repo if you havent already"
echo "https://github.com/redhat-cop/spring-rest"
echo
echo "Clone your forked repo so you can push to it"
echo "git clone https://github.com/${GITHUB_USERNAME}/spring-rest"

### empty commit
echo
echo to create an empty commit:
echo "git commit -m "empty-commit" --allow-empty && git push origin master"

### follow logs
echo
echo to follow logs:
echo "tkn pipeline logs -f"
echo
