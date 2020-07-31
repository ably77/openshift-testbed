#!/bin/bash

# source static variables
source vars.txt

# dynamic variables
worker_node=$(oc get machinesets -n openshift-machine-api | awk 'NR==2{ print $1 }')
CLUSTER_NAME=$(oc get -o jsonpath='{.status.infrastructureName}{"\n"}' infrastructure cluster)
AMI_ID=$(oc get machineset -n openshift-machine-api ${worker_node} -o yaml | grep ami- | awk '{ print $2 }')

# create generated directory if it doesnt exist
mkdir -p ./generated/${MACHINESET_NAME}
mkdir -p ./generated/${MACHINESET_NAME}/patches

# modify machineset name
sed -e "s/<machineset-name>/${MACHINESET_NAME}/g" templates/machineset.yaml > generated/${MACHINESET_NAME}/${MACHINESET_NAME}.yaml

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
- patches/ebs-storage.yaml
- patches/instance-spec.yaml
EOF

# create aws template kustomization patch
cat <<EOF >./generated/${MACHINESET_NAME}/patches/aws-template.yaml
---
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  name: ${MACHINESET_NAME}
spec:
  selector:
    matchLabels:
      machine.openshift.io/cluster-api-cluster: ${CLUSTER_NAME} 
      machine.openshift.io/cluster-api-machineset: ${CLUSTER_NAME}-${ROLE}-${REGION}${ZONE} 
  template:
    metadata:
      labels:
        machine.openshift.io/cluster-api-cluster: ${CLUSTER_NAME} 
        machine.openshift.io/cluster-api-machine-role: ${ROLE} 
        machine.openshift.io/cluster-api-machine-type: ${ROLE} 
        machine.openshift.io/cluster-api-machineset: ${CLUSTER_NAME}-${ROLE}-${REGION}${ZONE} 
    spec:
      providerSpec:
        value:
          iamInstanceProfile:
            id: ${CLUSTER_NAME}-worker-profile
          securityGroups:
            - filters:
                - name: tag:Name
                  values:
                    - ${CLUSTER_NAME}-worker-sg 
          subnet:
            filters:
              - name: tag:Name
                values:
                  - ${CLUSTER_NAME}-private-${REGION}${ZONE} 
          tags:
            - name: kubernetes.io/cluster/${CLUSTER_NAME} 
              value: owned
EOF

# create instance spec kustomization patch
cat <<EOF >./generated/${MACHINESET_NAME}/patches/instance-spec.yaml
---
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  name: ${MACHINESET_NAME}
spec:
  replicas: ${DESIRED_REPLICAS}
  template:
   providerSpec:
        value:
          ami: 
            id: ${AMI_ID}
          instanceType: ${INSTANCE_TYPE}
          placement:
            availabilityZone: ${REGION}${ZONE}
            region: ${REGION}
EOF

# create storage spec kustomization patch
cat <<EOF >./generated/${MACHINESET_NAME}/patches/ebs-storage.yaml
---
apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  name: ${MACHINESET_NAME}
spec:
  template:
   providerSpec:
        value:
          blockDevices:
            - ebs:
                iops: 0
                volumeSize: 120
                volumeType: gp2
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
