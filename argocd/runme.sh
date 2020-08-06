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

echo now deploying argoCD

# create argocd operator
oc apply -k argocd/deploy/operator/

# wait for operator deployment
./extras/waitfor-pod -n argocd -t 10 argocd-operator

# create argocd cluster
oc apply -k argocd/deploy/cr

# wait for cluster deployment
./extras/waitfor-pod -n argocd -t 10 argocd-application-controller

# sleep for 45 seconds
echo "sleeping for 45 seconds for argocd to finish installing"
sleep 45

# Login with the current admin password
argocd_server_password=$(oc get secret -n argocd argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd_route=$(oc get routes --all-namespaces | grep argocd-server-argocd.apps. | awk '{ print $3 }')

argocd --insecure --grpc-web login ${argocd_route}:443 --username admin --password ${argocd_server_password}