#!/bin/bash

# create a directory for the generated templates
mkdir generated_examples

# generate the templates

### openshift-testbed automatically deploys a cluster autoscaler, you can see the details at:
### https://github.com/ably77/openshift-testbed-argo-shared/blob/master/clusterautoscaler.yaml
./setup_clusterautoscaler.sh

### setup machine autoscaler
./setup_machineautoscaler.sh

# create the generated manifests
oc create -f generated_examples/
