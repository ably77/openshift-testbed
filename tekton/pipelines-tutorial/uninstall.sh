#!/bin/bash

### delete tekton pipeline resources
oc delete -f pipeline_resources/

### delete pipeline
oc delete -f pipelines/

### delete tasks
oc delete -f tasks/

### remove apps
oc delete -f apps/

### remove webhooks
oc delete -f github-webhooks/

### remove triggers
oc delete -f triggers/

### delete project
oc delete project pipelines-tutorial
