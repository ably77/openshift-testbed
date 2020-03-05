#!/bin/bash

### install tekton CLI
# brew tap tektoncd/tools
#brew install tektoncd/tools/tektoncd-cli

### install tekton pipelines operator

### create project
oc new-project pipelines-tutorial

### create tekton tasks
oc create -f tasks/

### create tekton pipeline
oc create -f pipelines/

### create tekton pipeline resources
oc create -f pipeline_resources/

### setup triggers
oc create -f triggers/

### setup github webhook
./github-webhooks/runme.sh

### manually run tekton pipeline
#oc create -f pipelinerun/build-and-deploy-pipelinerun.yaml
#tkn pipeline start build-and-deploy

### list pipeline
tkn pipeline list

### follow logs
echo
echo to follow logs:
echo "tkn pipeline logs -f"

### empty commit
echo
echo to create an empty commit:
echo "git commit -m "empty-commit" --allow-empty && git push origin master"
