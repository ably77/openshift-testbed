# commonly forked
repo1_url="https://github.com/ably77/openshift-testbed-apps"

# Login with the current admin password
argocd_server_password=$(oc get secret -n argocd argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d)
argocd_route=$(oc get routes --all-namespaces | grep argocd-server-argocd.apps. | awk '{ print $3 }')

argocd --insecure --grpc-web login ${argocd_route}:443 --username admin --password ${argocd_server_password}

# Add repo to be managed to argo repositories
argocd repo add ${repo1_url}
