#!/bin/bash

### Check if argocd CLI is installed
ARGOCLI=$(which argocd)
echo checking if argocd CLI is installed
if [[ $ARGOCLI == "" ]]
then
        echo
        echo "argocd CLI not installed"
        echo "see https://github.com/argoproj/argo-cd/blob/master/docs/cli_installation.md for installation instructions"
        echo "re-run the script after argocd CLI is installed"
        echo
        exit 1
fi

# delete argo apps
oc delete -f https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/argo-apps/meta/meta-frontend-apps.yaml
oc delete -f https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/argo-apps/meta/meta-backend-apps.yaml
oc delete -f https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/argo-apps/meta/meta-operators.yaml
oc delete -f https://raw.githubusercontent.com/ably77/openshift-testbed-apps/master/argo-apps/meta/meta-shared.yaml

# Wait for app deletion
./extras/wait-for-argo-app-deletion.sh

# delete argocd cluster
oc delete -f argocd/deploy/argocd-cluster.yaml

# delete argocd
oc delete -f argocd/deploy/argocd-operator.yaml

# delete CSVs
oc delete csv -n openshift-operators --all

# Delete argocd project
oc delete project argocd

# Switch to default project
oc project default

# delete CRDs
oc delete -f extras/crds/
oc delete crd checlusters.org.eclipse.che
oc delete crd grafanadashboards.integreatly.org grafanadatasources.integreatly.org grafanas.integreatly.org
oc delete crd podia.podium.com
oc delete crd kafkabridges.kafka.strimzi.io kafkaconnectors.kafka.strimzi.io kafkaconnects.kafka.strimzi.io kafkaconnects2is.kafka.strimzi.io kafkamirrormaker2s.kafka.strimzi.io kafkamirrormakers.kafka.strimzi.iokafkarebalances.kafka.strimzi.io kafkarebalances.kafka.strimzi.io kafkas.kafka.strimzi.io kafkatopics.kafka.strimzi.io kafkausers.kafka.strimzi.io
oc delete crd config.operator.tekton.dev
oc delete crd applications.argoproj.io appprojects.argoproj.io argocdexports.argoproj.io argocds.argoproj.io
