#!/bin/bash

DEPLOYMENT_PATH=deploy

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

read -p 'Quay Username: ' QUAY_USERNAME
echo $QUAY_USERNAME

### Generate Github Webhook Secret
sed -e "s/<GITHUB_TOKEN>/${GITHUB_TOKEN}/g" templates/webhook-secret.yaml.template > github-webhooks/wh-webhook-secret.yaml

### Generate Github Webhook TaskRun
sed -e "s/<GITHUB_ORG>/${GITHUB_ORG}/g" -e "s/<GITHUB_USERNAME>/${GITHUB_USERNAME}/g" -e "s/<CLUSTER_NAME>/${CLUSTER_NAME}/g" -e "s/<CLUSTER_DOMAIN>/${CLUSTER_DOMAIN}/g" templates/webhook-taskrun.yaml.template > github-webhooks/wh-create-spring-repo-webhook-run.yaml

oc new-project airlineprediction-generator-dev
oc new-project airlineprediction-generator-staging
oc new-project ${GITHUB_USERNAME}-cicd-environment

# create regcred secret
#oc create secret generic regcred --from-file=.dockerconfigjson="${QUAY_USERNAME}-airlinepredictiongenerator-auth.json" --type=kubernetes.io/dockerconfigjson
oc create -f regcred-secret.yaml

# bind admin Cluster Role to airlineprediction-sa in dev-environment and stage-environment projects
oc create -f rolebindings/airlineprediction-sa-admin-dev_rb.yaml
oc create -f rolebindings/airlineprediction-sa-admin-stage_rb.yaml

# run tasks
cat fullpipeline.yaml  | sed s"/\$QUAY_USERNAME/$QUAY_USERNAME/" | sed s"/\$GITHUB_USERNAME/$GITHUB_USERNAME/" | sed s"/\$DEPLOYMENT_PATH/$DEPLOYMENT_PATH/" | oc apply -f -

# add additional security policies for airlineprediction-sa
oc adm policy add-scc-to-user privileged -z airlineprediction-sa
oc adm policy add-role-to-user edit -z airlineprediction-sa

### setup github webhook
echo
echo setting up github webhook
./github-webhooks/runme.sh

# instructions
echo
echo Fork this repo if you havent already
echo https://github.com/bigkevmcd/airlineprediction-generator

echo
echo Clone your forked repo so you can push to it
echo git clone https://github.com/${GITHUB_USERNAME}/airlineprediction-generator

echo
echo to create an empty commit:
echo "git commit -m empty-commit --allow-empty && git push origin master"
