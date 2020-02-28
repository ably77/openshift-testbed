#!/bin/bash

# delete apps
oc delete -f multi-cluster/eu/apps/2
oc delete -f multi-cluster/eu/apps/1

# delete CRDs
oc delete -f crds/ --context=eu
