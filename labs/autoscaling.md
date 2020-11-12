# Autoscaling

## About the ClusterAutoscaler
The ClusterAutoscaler adjusts the size of an OpenShift Container Platform cluster to meet its current deployment needs. It uses declarative, Kubernetes-style arguments to provide infrastructure management that does not rely on objects of a specific cloud provider. The ClusterAutoscaler has a cluster scope, and is not associated with a particular namespace.

The ClusterAutoscaler increases the size of the cluster when there are pods that failed to schedule on any of the current nodes due to insufficient resources or when another node is necessary to meet deployment needs. The ClusterAutoscaler does not increase the cluster resources beyond the limits that you specify.

### Verifying the ClusterAutoscaler

#### View ClusterAutoscaler being deployed by argoCD
This demo automatically deploys a `default` ClusterAutoscaler as a part of the `openshift-testbed-apps` repository. You can see the details of the autoscaler here: (https://github.com/ably77/openshift-testbed-apps/tree/master/kustomize/manifests/cluster-config/cluster-autoscaler/base)

#### View ClusterAutoscaler with CLI
```
oc get clusterautoscaler default -o yaml
```

#### View ClusterAutoscaler in the UI
In the Administrator view, navigate to Administration --> Cluster Settings and select ClusterAutoscaler

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/autoscaler1.png)

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/autoscaler2.png)


## About the MachineAutoscaler
The MachineAutoscaler adjusts the number of Machines in the MachineSets that you deploy in an OpenShift Container Platform cluster. You can scale both the default worker MachineSet and any other MachineSets that you create. The MachineAutoscaler makes more Machines when the cluster runs out of resources to support more deployments. Any changes to the values in MachineAutoscaler resources, such as the minimum or maximum number of instances, are immediately applied to the MachineSet they target.

### Creating MachineAutoscalers

Navigate to the autoscaling directory
```
cd autoscaler/machineautoscaler
```

## Modify parameters in patches directory:
```
apiVersion: "autoscaling.openshift.io/v1beta1"
kind: "MachineAutoscaler"
metadata:
  name: machine-autoscaler
spec:
  scaleTargetRef:
    name: <target machineset name>
---
apiVersion: "autoscaling.openshift.io/v1beta1"
kind: "MachineAutoscaler"
metadata:
  name: machine-autoscaler
spec:
  minReplicas: <number of minimum replicas>
  maxReplicas: <number of max replicas>
```

## optional: kustomize build to test output
```
oc kustomize .
```

Example output:
```
% oc kustomize .
apiVersion: autoscaling.openshift.io/v1beta1
kind: MachineAutoscaler
metadata:
  name: 1-machine-autoscaler
  namespace: openshift-machine-api
spec:
  maxReplicas: 10
  minReplicas: 1
  scaleTargetRef:
    apiVersion: machine.openshift.io/v1beta1
    kind: MachineSet
    name: 1-demo-machineset
```

## Apply manifests
```
oc apply -k .
```

### Verify that your MachineAutoscalers have been created

#### Using the CLI
```
oc get machineautoscalers -n openshift-machine-api
```

Output should look similar to below:
```
% oc get machineautoscalers -n openshift-machine-api
NAME                   REF KIND     REF NAME                          MIN   MAX   AGE
1-machine-autoscaler   MachineSet   ly-demo-8qxpc-worker-us-west-1b   1     10    19s
```

#### Using the UI
In the Administrator view, navigate to Compute --> Machine Autoscalers

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/autoscaler3.png)