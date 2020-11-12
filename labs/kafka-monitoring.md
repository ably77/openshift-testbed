# Monitoring Kafka with Grafana and Prometheus

## About Grafana and Prometheus
Grafana is an open platform for beautiful analytics and monitoring. For more information please visit the [Grafana website](https://grafana.com/)

Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. For more information please visit the [Prometheus website](https://prometheus.io/)


## About the Grafana Operator
The Grafana Operator in OperatorHub manages the full lifecycle for deploying and managing a Grafana instance on Kubernetes and OpenShift. The operator's goal is to reduce human configuration and maintenance activities by automating the tasks required when operating a Grafana cluster such as installing, upgrading, importing dashboards, importing data sources, and installing plugins.

See the [Official GitHub](https://github.com/integr8ly/grafana-operator) of the integr8ly grafana operator for more details

## About this Lab
`openshift-testbed` deploys Prometheus and Grafana in order to provide dashboards for the kafka deployment and more specifically the `iotdemo-app`, `kafka-loadtest-app`, and `airline-prediction-stream` application topics

## Lab
Navigate to the Grafana Homepage:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/kafka-monitoring1.png)

### Strimzi Kafka Dashboard
Select the Strimzi Kafka Dashboard to drill down into specific panels such as health of brokers, incoming/outgoing byte rate, incoming messages rate, and much more:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/kafka-monitoring2.png)

You can further drill down into dashboards on specific topics, brokers, or even other clusters by selecting from the dropdowns:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/kafka-monitoring3.png)

### Kafka Exporter Dashboard
Select the Kafka Exporter Dashboard from he top left. Here you can drill down into metrics that are exposed using the popular kafka-exporter project. The kafka-exporter plugin is automatically configured by the kafka operator, making it extremely simple to set up:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/kafka-monitoring4.png)

### Strimzi Zookeeper Dashboard
Select the Strimzi Zookeeper Dashboard from he top left. Here you can drill down into specific panels such as health of the Zookeeper deployment, outstanding requests, latency, and JVM dashboards
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/kafka-monitoring5.png)
