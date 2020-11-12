# Monitoring

REF: (https://docs.openshift.com/container-platform/4.3/monitoring/cluster_monitoring/about-cluster-monitoring.html)

OpenShift Container Platform includes a pre-configured, pre-installed, and self-updating monitoring stack that is based on the Prometheus open source project and its wider eco-system. It provides monitoring of cluster components and includes a set of alerts to immediately notify the cluster administrator about any occurring problems and a set of Grafana dashboards.

All the components of the monitoring stack are monitored by the stack and are automatically updated when OpenShift Container Platform is updated.

In addition to the components of the stack itself, the monitoring stack monitors:
- CoreDNS
- Elasticsearch (if Logging is installed)
- etcd
- Fluentd (if Logging is installed)
- HAProxy
- Image registry
- Kubelets
- Kubernetes apiserver
- Kubernetes controller manager
- Kubernetes scheduler
- Metering (if Metering is installed)
- OpenShift apiserver
- OpenShift controller manager
- Operator Lifecycle Manager (OLM)
- Telemeter client

## Navigate to the Grafana Home Dashboard
In the Administrator view, navigate to the Monitoring tab and select Dashboards. This will open up a new window for Grafana, you will have to enter your cluster login credentials again to grant access and navigate to the pre-built Grafana dashboards

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/monitoring1.png)

### View Cluster Metrics
Select the dashboard `Kubernetes / Compute Resources / Cluster`. Here you should see information regarding cluster CPU and MEM utilization, commitment, and quota

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/monitoring2.png)

### View Node Metrics
Select the dashboard `USE Method / Node`. Here you should see information regarding cluster CPU, MEM, Network, and Storage utilization and saturation

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/monitoring3.png)

### View Metrics per Namespace
Select the dashboard `Kubernetes / Compute Resources / Namespace (Pods)`. Here you should see information regarding cluster CPU, MEM, and Network usage and quota filtered per namespace.

Select `myproject` as your `namespace` to see metrics on apps deployed in `openshift-testbed` such as the iot-demo app or kafka.

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/monitoring4.png)

### View Metrics of a specific Pod
Select the dashboard `Kubernetes / Compute Resources / Pod`. Here you should see information regarding cluster CPU, MEM, and Network usage and quota filtered per Namespace/Pod.

Select `basic-spring-boot-build` as your `namespace` and select the `basic-spring-boot-1-` deployment to see metrics on your spring boot example deployment

![](https://github.com/ably77/Standard-OCP-Workshop/blob/master/resources/monitoring5.png)