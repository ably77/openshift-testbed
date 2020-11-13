# Openshift Test Bed
The purpose of this repo is to show several examples of Openshift and upstream Kubernetes concepts as reference examples that can be used and expanded on.

### Business Value Goals:
The focus of openshift-testbed is to show value in the following key areas:
- Standardization - Applications leverage GitOps patterns to standardize application and configuration management
- Reliability - Applications leverage Kubernetes Operators where possible to simplify management and operations
- Observability - Monitoring provides visibility from infrastructure up to the application layers
- Portability - Build on OpenShift, run anywhere
- Automation - Declarative cluster, application, and configuration management allows for agile operations
- Self Service - Use of software catalog to explore, learn, and develop using new and certified solutions

## Platform Components and Application Examples

Backend Platform Components:
- ArgoCD Operator (gitops)
- Strimzi Operator (kafka)
- ActiveMQ Artemis Operator (mq)
- Prometheus Operator (metrics)
- Integr8ly Grafana Operator (dashboards)
- Openshift Pipelines Operator (CI/CD)
- Container Security Operator (container scanning)
- Node Feature Discovery Operator (node label discovery)
- Openshift Service Mesh Operator (istio)


Frontend Applications:
- Real-time Streaming Temperature IoT Dashboard Application
- Podium Collaboration Portal
- Openshift CodeReady Workspaces - web based IDE
- manuELA IoT Manufacturing Dashboard
- Airline Prediction Generator (kafka producer) tekton pipeline
- Airline Prediction Kafka Streams app
- Basic Spring Boot tekton pipeline
- Kafka load testing app
- Istio Book Info app

## Concepts/Examples Reviewed

Developer Tooling:
- Builds with source-to-image and docker strategies
- CI/CD with Openshift Pipelines (Tekton)
- CI/CD with Jenkins
- CodeReady Workspaces (web-based IDE)
- GitOps with ArgoCD
- Service Mesh monitoring and tracing (Kiali & Jaeger)

Cloud Native App Development:
- Streaming Architectures
- GitOps
- Cloud Native CI/CD
- Service Mesh
- Introductory ML/AI

Operations:
- Scaling and Upgrading your cluster
- Autoscaling
- Upgrading
- Infrastructure Node Pools
- Monitoring
- Multi-cloud
- Failure recovery
- Centralized Configuration Management
- Image Vulnerability Scanning
- Node Feature Discovery

## Prerequisites for Lab:
- Multi Node Openshift Cluster - this guide has been tested on:
     - AWS - 3x m5.xlarge workers (4CPU x 16GB RAM)
     - Azure - 3x Standard_D3s_v3 workers (4CPU x 16GB RAM)
     - GCP - 3x n2-standard-4 (4CPU x 16GB RAM)
- Admin Privileges (i.e. cluster-admin RBAC privileges or logged in as system:admin user)
- `argo` client installed (see https://github.com/argoproj/argo-cd/blob/master/docs/cli_installation.md)
- `oc` client installed (see https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/)
- Storage configured on cluster (this demo has been tested on AWS, Azure, GCP, and vSphere storage)

## Running this Demo

### Running and automated build
This is able to build and deploy itself using Openshift Build strategies.

AWS Deployment:
```
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/build-strategies/build-internal-registry/docker/openshift-testbed-installer/aws-openshift-testbed-installer.yaml
```

Azure Deployment:
```
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/build-strategies/build-internal-registry/docker/openshift-testbed-installer/azure-openshift-testbed-installer.yaml
```

GCP Deployment:
```
oc create -f https://raw.githubusercontent.com/ably77/openshift-testbed/master/build-strategies/build-internal-registry/docker/openshift-testbed-installer/gcp-openshift-testbed-installer.yaml
```

What this will do:
- Create a BuildConfig that points to a git repo (https://github.com/ably77/oc-client)
- Builds oc-client image including demo dependencies (git, openshift-testbed, argo CLI, tkn CLI)
- Deploys built image and installs openshift-testbed

To view the logs, replace the hash with your own:
```
oc logs openshift-testbed-installer-1-p4t72 -n default -f
```

### Running the demo manually
If you have an Openshift cluster up, `argocd` CLI installed, and are authenticated to the `oc` CLI just run the installation script below and follow the output in your console. The script itself has more commented information on the steps and commands if you prefer to run through this demo step-by-step
```
./scripts/runme.sh <provider>

Example:
./scripts/runme.sh aws
./scripts/runme.sh azure
./scripts/runme.sh gcp
./scripts/runme.sh vsphere
```

### Opening routes
Once the install is complete, run the script below to open demo routes on your local machine
```
./scripts/open-routes.sh
```

## Workshop Labs
Lab instructions have been created to help walk you through the capabilities of `openshift-testbed`
- [Lab - Navigating ArgoCD](https://github.com/ably77/openshift-testbed/blob/master/labs/argocd.md)
- [Lab - Autoscaling](https://github.com/ably77/openshift-testbed/blob/master/labs/autoscaling.md)
- [Lab - Cluster Monitoring](https://github.com/ably77/openshift-testbed/blob/master/labs/cluster-monitoring.md)
- [Lab - Vulnerability Scanning using Container Security Operator ](https://github.com/ably77/openshift-testbed/blob/master/labs/container-security-operator.md)
- [Lab - Monitoring Kafka with Grafana and Prometheus](https://github.com/ably77/openshift-testbed/blob/master/labs/kafka-monitoring.md)
- [Lab - Scaling and Upgrading your Cluster ](https://github.com/ably77/openshift-testbed/blob/master/labs/scaling-and-upgrading.md)
- [Lab - Node Feature Discovery](https://github.com/ably77/openshift-testbed/blob/master/labs/node-feature-discovery.md)

## Uninstall
```
./uninstall.sh
```
