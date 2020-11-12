# Scaling and Upgrading your Cluster

### Scaling using the UI

To scale your cluster with the UI, simply navigate to the Compute --> MachineSets section in your Administrators UI

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/scale1.png)

Select a machineSet and scale it from 1 to 2

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/scale2.png)

Navigate to the Nodes/Machine view to see your new machine being created

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/scale3.png)

### Scaling using the CLI
Get machine sets
```
oc get machinesets -n openshift-machine-api
```

Edit machine set replica from 1 to 2
```
oc edit machinesets -n openshift-machine-api <MACHINE_SET_NAME>
```

Edit should look similar to below:
```
ApiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  creationTimestamp: "2020-03-05T14:51:09Z"
  generation: 1

<...>

spec:
  replicas: 1

<...>
```

Re-run get machine sets to see change in DESIRED/CURRENT state:
```
$ oc get machinesets -n openshift-machine-api
NAME                              DESIRED   CURRENT   READY   AVAILABLE   AGE
ly-demo-7mb6r-worker-us-east-1a   1         1         1       1           10h
ly-demo-7mb6r-worker-us-east-1b   1         1         1       1           10h
ly-demo-7mb6r-worker-us-east-1c   1         1                             10h
```

You can also check to see your machine objects:
```
$ oc get machines -n openshift-machine-api
NAME                                    PHASE         TYPE        REGION      ZONE         AGE
ly-demo-7mb6r-master-0                  Running       m5.xlarge   us-east-1   us-east-1a   10h
ly-demo-7mb6r-worker-us-east-1a-7pwjx   Running       r5.xlarge   us-east-1   us-east-1a   10h
ly-demo-7mb6r-worker-us-east-1b-mbrxg   Running       r5.xlarge   us-east-1   us-east-1b   10h
ly-demo-7mb6r-worker-us-east-1c-rrd2v   Provisioned   r5.xlarge   us-east-1   us-east-1c   77s
```


### Upgrading your Cluster using the UI

Navigate to the Administrators View > Administration > Cluster Settings. Select the upgrade candidate channel to select and upgrade

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/upgrade2.png)

Upgrading will take about ~30 minutes to complete

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/upgrade3.png)

Notice that openshift-testbed workloads survive the upgrade without issue. There may be some minor downtime for components depending on whether they're set up for HA in openshift-testbed.