#!/bin/bash

CONTEXT_NAME="dr"

# delete apps
oc delete -f multi-cluster/${CONTEXT_NAME}/apps/2
oc delete -f multi-cluster/${CONTEXT_NAME}/apps/1

# delete project
oc delete -f multi-cluster/${CONTEXT_NAME}/${CONTEXT_NAME}-project.yaml

# delete CRDs
oc delete -f crds/ --context=${CONTEXT_NAME}
