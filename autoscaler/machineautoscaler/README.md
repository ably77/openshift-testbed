# Setting up a Machine Autoscaler


## Modify parameters in patches:
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

## kustomize build
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


