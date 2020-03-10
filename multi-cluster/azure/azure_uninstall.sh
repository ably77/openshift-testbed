#!/bin/bash

# delete apps
oc delete -f multi-cluster/azure/apps/2
oc delete -f multi-cluster/azure/apps/1

# delete CRDs
oc delete -f crds/ --context=azure
