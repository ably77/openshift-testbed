# Openshift Test Bed
The purpose of this repo is to show several examples of Openshift and upstream Kubernetes concepts as reference examples that can be used and expanded on.

Backend Platform Components:
- ArgoCD (gitops + continuous delivery)
- Kafka (streaming pub/sub)
- Prometheus (metrics)
- Grafana (dashboards)

Frontend Applications Examples:
- Real-time Streaming Temperature IoT Dashboard Application
- Basic Spring Boot tekton pipeline
- Airline Prediction Generator (kafka producer) tekton pipeline
- Airline Prediction Kafka Stream
- Taxi Go app tekton pipeline
- Cat/Dog vote app tekton pipeline
- Kafka load testing app

Developer Tooling Examples:
- Tekton (pipelines)
- CodeReady Workspaces
- argoCD developer workflow

Cloud Native Development Concepts:
- Streaming Architectures
- GitOps workflow
- Cloud Native CI/CD
- Centralized Configuration Management
- Introductory ML/AI

Operations Concepts:
- Scaling and Upgrading your cluster
- Autoscaling
- Infrastructure Node Pools
- Monitoring
- Multi-cluster demonstration
- Multi-cloud demonstration

## Workshop Labs
Lab instructions have been created to help walk you through the capabilities of `openshift-testbed`
- [Lab 1.1 - Cluster Installation on Azure](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab1.1-Cluster_Installation_Azure)
- [Lab 1.2 - Cluster Installation on AWS](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab1.2-Cluster_Installation_AWS)
- [Lab 2 - Installing Openshift Testbed](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab2-Install_Openshift_Testbed)
- [Lab 3 - Deploy a Spring Boot Tekton Pipeline with Git Push Webhook Trigger](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab3-Deploy_Springboot_Pipeline)
- [Lab 4 - Demonstrating Codeready Workspaces](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab4-CodeReady_Workspaces)
- [Lab 5 - Configuration Management Using ArgoCD + Tekton Pipelines with CodeReady Workspaces](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab5-Deploy-Voteapp-Pipeline)
- [Lab 6 - Scaling and Upgrading your Cluster](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab6-Scaling_and_Upgrading)
- [Lab 7 - Applying Autoscaling](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab7-Autoscalers)
- [Lab 8 - Monitoring](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab8-Monitoring)
- [Lab 9 - Chaos Engineering](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab9-Chaos_Engineering)
- [Lab End - Destroying the Cluster](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab_End-Destroying_the_Cluster)
- [Extras](https://github.com/ably77/Standard-OCP-Workshop/tree/master/Lab9-Chaos_Engineering)

## Prerequisites for Lab:
- Multi Node Openshift Cluster - this guide has been tested on:
     - AWS - 2x m5.xlarge workers (4CPU x 16GB RAM)
     - Azure - 2x Standard_D3s_v3 workers (4CPU x 16GB RAM)
- Admin Privileges (i.e. cluster-admin RBAC privileges or logged in as system:admin user)
- `argo` client installed (see https://github.com/argoproj/argo-cd/blob/master/docs/cli_installation.md)
- `oc` client installed (see https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/)
- Tekton `tkn` client installed
- Storage configured on cluster (this demo has been tested on AWS and Azure storage)

## Running this Demo

If you have an Openshift cluster up, `argocd` CLI installed, and are authenticated to the `oc` CLI just run the installation script below. The script itself has more commented information on the steps and commands if you prefer to run through this demo manually.
```
./runme.sh
```

This script will:
- Deploy necessary demo CRDs
- Deploy and argoCD
- Configure argoCD to demo repositories
- Open ArgoCD Route
- Deploy the Strimzi Kafka Operator
- Deploy an ephemeral kafka cluster with 3 broker nodes and 3 zookeeper nodes
- Create three Kafka topics (my-topic1, my-topic2, my-topic3)
- Deploy Prometheus
- Deploy the Integr8ly Grafana Operator
- Add the Prometheus Datasource to Grafana
- Add Strimzi Kafka, Kafka Exporter, and Zookeeper Dashboards
- Deploy the IoT Temperature Sensors Demo using ArgoCD
- Open Grafana Route
- Open IoT Temperature Sensors Demo app route
- Deploy sample cronJob1 and cronJob2
- Deploy CodeReady Workspaces
- Create an Eclipse Che cluster with this demo's repositories
- Deploy Tekton Pipelines Operator using ArgoCD

## About Kafka
Apache Kafka is a highly scalable and performant distributed event streaming platform great for storing, reading, and analyzing streaming data. Originally created at LinkedIn, the project was open sourced to the Apache Foundation in 2011. Kafka enables companies looking to move from traditional batch processes over to more real-time streaming use cases.

![](https://github.com/ably77/strimzi-openshift-demo/blob/master/resources/architecture1.jpg)

The diagram above is a common example of many fast-data (streaming) solutions today. With kafka as a core component of your architecture, multiple raw data sources can pipe data to Kafka, be analyzed in real-time by tools such as Apache Spark, and persisted or consumed by other microservices

### About Kubernetes Operators
An Operator is a method of packaging, deploying and managing a Kubernetes application. A Kubernetes application is an application that is both deployed on Kubernetes and managed using the Kubernetes APIs and kubectl tooling. With Operators, the kubernetes community gains a standardized way to build, deploy, operate, upgrade, and troubleshoot Kubernetes applications.

The full list of Operators can be found on [operatorhub.io](https://operatorhub.io/), the home for the Kubernetes community to share Operators.

#### About the Strimzi Kafka Operator
Today we will be using the [strimzi.io](https://operatorhub.io/operator/strimzi-kafka-operator) Kafka Operator. Strimzi makes it easy to run Apache Kafka on OpenShift or Kubernetes.

Strimzi provides three operators:

Cluster Operator
Responsible for deploying and managing Apache Kafka clusters within an OpenShift or Kubernetes cluster.

Topic Operator
Responsible for managing Kafka topics within a Kafka cluster running within an OpenShift or Kubernetes cluster.

User Operator
Responsible for managing Kafka users within a Kafka cluster running within an OpenShift or Kubernetes cluster.

#### About the Integr8ly Grafana Operator
A Kubernetes Operator based on the Operator SDK for creating and managing Grafana instances.

The Operator is available on [Operator Hub](https://operatorhub.io/operator/grafana-operator).

It can deploy and manage a Grafana instance on Kubernetes and OpenShift. The following features are supported:

* Install Grafana to a namespace
* Import Grafana dashboards from the same or other namespaces
* Import Grafana datasources from the same namespace
* Install Plugins (panels) defined as dependencies of dashboards

Why Grafana?
- Quickly becoming a de-facto standard in cloud-native monitoring
- Strong community support

#### About ArgoCD
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

Why Argo CD?
- Application definitions, configurations, and environments should be declarative and version controlled.
- Application deployment and lifecycle management should be automated, auditable, and easy to understand.

#### About the Codeready Workspaces Operator
Red Hat CodeReady Workspaces is a developer workspace server and cloud IDE. Workspaces are defined as project code files and all of their dependencies neccessary to edit, build, run, and debug them. Each workspace has its own private IDE hosted within it. The IDE is accessible through a browser. The browser downloads the IDE as a single-page web application.

Red Hat CodeReady Workspaces provides:
- Workspaces that include runtimes and IDEs
- RESTful workspace server
- A browser-based IDE
- Plugins for languages, framework, and tools
- An SDK for creating plugins and assemblies

Why CodeReady Workspaces?
- Pre-configured workspaces allow for quicker onboarding of users onto the platform
- Removal of local development workflows
- Develop solutions on the same platform that is running them
- Maintain security of intellectual property (IP) on the platform itself
- Fully capable web-based IDE allows users to work wherever there is internet and browser access

## Uninstall
```
./uninstall.sh
```
