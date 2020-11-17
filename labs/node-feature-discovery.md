# Node Feature Discovery

## About the Node Feature Discovery Operator
The Node Feature Discovery Operator detects hardware features available on each node (i.e. GPU) in a Kubernetes cluster, and advertises those features using node labels. These labels can then be used to facilitate scheduling of workloads on OpenShift.

NFD runs in the background, re-labeling nodes every 60 seconds (by default) so that any changes in the node capabilities are detected [see link](https://docs.01.org/kubernetes/nfd/using.html)

## About this Lab
`openshift-testbed` automatically deploys and configures the nfd-operator as an argo application. You can immediately start to see detected node labels in your cluster once the operator is installed.

## Lab

### View Node Feature Discovery Operator
Navigate to the Installed Operators tab in the OpenShift UI in the `openshift-operators` project and select the Node Feature Discovery Operator:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/nfd1.png)

Here you can see more detail about the Node Feature Discovery Operator such as status and health of components
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/nfd2.png)

Since the Operator starts working immediately after it is deployed, nodes in the cluster should already be labeled

### Viewing discovered node labels
In the OpenShift UI, navigate to Compute --> Nodes. Select a worker node and navigate to the YAML tab. Under labels, you should see labels discovered by the NFD Operator with the key starting with `feature.node.kubernetes.io`
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/nfd3.png)


## Conclusion
In this lab we have shown how to leverage the Node Feature Discovery Operator to detect and advertise node features using node labels.
