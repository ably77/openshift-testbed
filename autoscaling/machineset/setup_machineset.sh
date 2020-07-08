
#!/bin/bash

role=kafka
second_role=stateful
instancetype=r5.xlarge
region=us-east-1
zone=c
desired_replicas=3

worker_node=$(oc get machinesets -n openshift-machine-api | awk 'NR==2{ print $1 }')
clusterid=$(oc get machineset -n openshift-machine-api $worker_node -o yaml | grep machine.openshift.io/cluster-api-cluster: | awk 'NR==1{ print $2 }')
ami_id=$(oc get machineset -n openshift-machine-api $worker_node -o yaml | grep ami- | awk '{ print $2 }')

sed -e "s/<clusterID>/${clusterid}/g" -e "s/<role>/${role}/g" -e "s/<second_role>/${second_role}/g" -e "s/<INSTANCETYPE>/${instancetype}/g" -e "s/<REGION>/${region}/g" -e "s/<ZONE>/${zone}/g" -e "s/<AMIID>/${ami_id}/g" -e "s/<REPLICAS>/${desired_replicas}/g" machineset.template.yaml > generated/machineset-$role-$region$zone.yaml
