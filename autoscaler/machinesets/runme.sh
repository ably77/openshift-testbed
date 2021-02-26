#!/bin/bash

# Get source of variable file
read -p 'Name of variables file (i.e. vars.txt): ' varfile

# source static variables
source ${varfile}

# dynamic variables
worker_node=$(oc get machinesets -n openshift-machine-api | awk 'NR==2{ print $1 }')
CLUSTER_NAME=$(oc get -o jsonpath='{.status.infrastructureName}{"\n"}' infrastructure cluster)
AMI_ID=$(oc get machineset -n openshift-machine-api ${worker_node} -o jsonpath="{.spec.template.spec.providerSpec.value.ami.id}")

# create generated directory if it doesnt exist
mkdir -p ./generated/${MACHINESET_NAME}
mkdir -p ./generated/${MACHINESET_NAME}/patches

# modify machineset name
sed -e "s/<cluster-name>/${CLUSTER_NAME}/g" -e "s/<role>/${ROLE}/g" -e "s/<region>/${REGION}/g" -e "s/<zone>/${ZONE}/g" templates/machineset.yaml > generated/${MACHINESET_NAME}/${MACHINESET_NAME}.yaml

# create kustomization.yaml
cat <<EOF >./generated/${MACHINESET_NAME}/kustomization.yaml
---
# kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# list of Resource Config to be Applied
resources:
- ${MACHINESET_NAME}.yaml

# namespace to deploy all Resources to
namespace: openshift-machine-api

# name of app
namePrefix: 1-

# labels added to all Resources
commonLabels:
  machine.openshift.io/cluster-api-cluster: ${CLUSTER_NAME}
  node-role.kubernetes.io/${ROLE}: ""
  node-role.kubernetes.io/${SECOND_ROLE}: "" 

patchesStrategicMerge:
- patches/aws-template.yaml
EOF

# create aws template kustomization patch
cat <<EOF >./generated/${MACHINESET_NAME}/patches/aws-template.yaml
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  name: ${CLUSTER_NAME}-${ROLE}-${REGION}${ZONE}
spec:
  replicas: ${DESIRED_REPLICAS}
  template:
    spec:
      providerSpec:
        value:
          ami:
            id: ${AMI_ID}
          apiVersion: awsproviderconfig.openshift.io/v1beta1
          blockDevices:
            - ebs:
                iops: 0
                volumeSize: 120
                volumeType: gp2
          instanceType: ${INSTANCE_TYPE}
EOF

# output success
echo "generated machineset in directory generated/${MACHINESET_NAME}"
echo "now doing a dry run of the generated machineset.."

# test the generated manifests
echo
echo testing the generated manifests using --dry-run
echo
oc apply -k generated/${MACHINESET_NAME} --dry-run=client
echo

# run the generated manifests
read -p "Select 'y' to deploy the machineset:" -n1 -s c
if [ "$c" = "y" ]; then
        echo yes
oc apply -k generated/${MACHINESET_NAME}

echo

else
        echo no
fi
