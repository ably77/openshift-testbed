#!/bin/bash

# delete apps
oc delete -f multi-cluster/dr/apps/2
oc delete -f multi-cluster/dr/apps/1

# delete dr project from argocd
oc delete -f multi-cluster/dr/dr-project.yaml
