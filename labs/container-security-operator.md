# Container Security Operator

## About the Quay Container Security Operator
The Quay Container Security Operator (CSO) brings Quay and Clair metadata to Kubernetes / OpenShift. Starting with vulnerability information the scope will get expanded over time. If it runs on OpenShift, the corresponding vulnerability information is shown inside the OCP Console. The Quay Container Security Operator enables cluster administrators to monitor known container image vulnerabilities in pods running on their Kubernetes cluster. 

The controller sets up a watch on pods in the specified namespace(s) and queries the container registry for vulnerability information. If the container registry supports image scanning, such as Quay with Clair, then the Operator will expose any vulnerabilities found via the Kubernetes API in an ImageManifestVuln object. This Operator requires no additional configuration after deployment, and will begin watching pods and populating ImageManifestVulns immediately once installed.

## About this Lab
`openshift-testbed` automatically deploys and configures the container-security-operator as an argo application. You can immediately start to see image vulnerabilities in your cluster, severity, and how to address the issues.

## Lab

### OpenShift Homepage Integration
Once deployed, the Quay Container Security Operator automatically becomes visible in the homepage of OpenShift:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/cso1.png)

### Image Manifest Vulnerabilities
Selecting View All in at the bottom of that panel will lead you to the Image Manifest Vulnerabilities page which provides the vulnerabilities detected in the cluster in a list view:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/cso2.png)

### Deeper Dive Detail
Selecting a particular manifest hyperlink in the right column will link you to [quay.io](quay.io) which will provide even deeper detail into the specific vulnerability CVE, severity, package, and "fixed-in" version information:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/cso3.png)

## Conclusion
In this lab we have shown how to leverage the Quay Container Security Operator to monitor, detect, and view image vulnerabilities in your OpenShift cluster. Leverage these capabilities in order to quickly view and remediate image vulnerabilities in your containers.