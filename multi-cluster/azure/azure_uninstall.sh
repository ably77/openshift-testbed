#!/bin/bash

CONTEXT_NAME="azure"

# delete apps
oc delete -f multi-cluster/${CONTEXT_NAME}/apps/2
oc delete -f multi-cluster/${CONTEXT_NAME}/apps/1

# delete CRDs
oc delete -f crds/ --context=${CONTEXT_NAME}
