# GitOps Lab

## What is GitOps?
GitOps is a set of practices that use git to manage infrastructure and application configurations. A Git repository in GitOps is considered the only source of truth and contains the entire state of the system so that the trail of changes to the system state are visible and auditable.

Benefits of GitOps - repeatability, predictability, auditability, and accessibility

## What is Kustomize?
Kustomize is a tool designed to let users customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is

Kustomize is not a templating framework, it is a patching framework that works through the concept of inheritance. The tool is built into Kubernetes as of 1.14 which means there is full support out-of-the-box


## About this Lab
By default, this demo will deploy and function as a visual demonstration of concepts such as Autoscaling, Cluster Monitoring, Vulnerability Scanning, Kafka Monitoring, Scaling and Upgrading your Cluster, and Node Feature Discovery. 

However, in order to successfully demonstrate the GitOps portions of `openshift-testbed` it is necessary to fork and modify a few components in your own repo so that you have full control. This will allow the user to declaritively control configuration changes such as modifying a modify names of applications, replica set, upgrading the version of an Operator, make changes to configmaps, and even add new applications to `openshift-testbed`

Declarative configuration through GitOps is a key concept to use in order to provide consistency and standardization across multiple environments as you scale. Using Git as the source of truth reduces configuration drift and increases accountability and auditability.

The `openshift-testbed-apps` repo has been configured in a way to make GitOps easy to do.

## Demo Guide

### Uninstall openshift-testbed if already installed
If you already have `openshift-testbed` installed, run the command below to uninstall
```
./scripts/uninstall.sh
```

### Forking openshift-testbed-apps

1. Make a fork of the `openshift-testbed-apps` repo: (https://github.com/ably77/openshift-testbed-apps)

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops1.png)

1. In your fork, navigate to argo-apps/backend/meta/patches and select `github-username-patch.yaml`

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops2.png)

1. Edit the `github-username-patch.yaml` and replace the github username with your own and commit your changes

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops3.png)

1. Do steps 2 & 3 for the `github-username-patch.yaml` in `cluster-config/meta/patches`, `dev/aws/meta/patches`, and `operators/meta/patches/`

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops4.png)

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops5.png)

![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/gitops6.png)

1. Lastly, in your `openshift-testbed` repo, modify the `GITHUB_USERNAME` variable to reflect your own fork:
```
% cat vars.txt 
# openshift-testbed-apps repo variables

# dev file for openshift-testbed codeready workspace
CODEREADY_DEVFILE_URL="https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/kustomize/instances/overlays/backend/codeready-workspaces-service/dev-file/openshift-testbed-dev-file.yaml"

# change your github username if you have forked this repo
# default is ably77
GITHUB_USERNAME="<input github username here>"
```

## Redeploy `openshift-testbed`
If you have an Openshift cluster up, `argocd` CLI installed, and are authenticated to the `oc` CLI just run the installation script below and follow the output in your console.
```
./scripts/runme.sh <provider>

Example:
./scripts/runme.sh aws
./scripts/runme.sh azure
./scripts/runme.sh gcp
./scripts/runme.sh vsphere
```
