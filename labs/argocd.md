# ArgoCD Lab

## About ArgoCD
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

Why Argo CD?
- Application definitions, configurations, and environments should be declarative and version controlled.
- Application deployment and lifecycle management should be automated, auditable, and easy to understand.

## ArgoCD and openshift-testbed
This demo significantly leverages argoCD and gitops principles in order to reliably deploy and manage applications on the OpenShift cluster. `openshift-testbed` uses git as the single source of truth to deploy applications (frontend, backend, and operators) as well as cluster configuration (clusterautoscalers, RBAC, etc.). Any changes made to the git repo will be automatically synced with the cluster on a specified interval. 

Leveraging gitops principles, kustomize, and argoCD makes it simple to organize and design a demo that supports many platforms and various configurations.

## About the ArgoCD Operator
https://github.com/argoproj-labs/argocd-operator
The ArgoCD Operator in OperatorHub manages the full lifecycle for Argo CD and it's components. The operator's goal is to reduce human maintenance activities by automating the tasks required when operating an Argo CD cluster such as upgrading, backing up and restoring as needed. In addition, the operator aims to provide deep insights into the Argo CD environment by configuring Prometheus and Grafana to aggregate, visualize and expose the metrics already exported by Argo CD.

## About this Lab
The intention of this lab is to show how to navigate through the argoCD dashboard to view the `openshift-testbed` applications deployed on your OpenShift cluster

### Log in to the dashboard
The argoCD Operator supports SSO using OpenShift oAuth, so we can log in using our kubeadmin or other designated user

Select `Login Via Openshift` in the argoCD homepage and enter your credentials to get started
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo1.png)

### Overview View Options
ArgoCD has multiple ways to view the status of your overall applications

Tile View:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo2.png)

List View:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo3.png)

Pie Chart View:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo4.png)

### Application View Options
Select an application such as the bookinfo-app. Here you can dive deeper into the specific components of a particular application. There are multiple ways to view your apps as well in the top right corner (component view, networking view, and list)

Selecting App Details in the top left corner allow you to see specifics on the overall health of the Application, parameters, events, and manifests as well as letting you configure argoCD specific parameters such as sync policy:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo5.png)

You can further drill down into any particular component such as a Pod, Deployment, or Service by selecting the tile in the UI to see summary details, events, logs, and more information:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/argo6.png)







