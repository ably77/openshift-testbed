# Tekton Pipelines Demo - Pet Clinic Web App

## About Tekton Pipelines Demo
This repo is CI/CD demo using [Tekton](http://www.tekton.dev) pipelines on OpenShift which builds and deploys the [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) sample Spring Boot application. This demo creates:
* 3 namespaces for CI/CD, DEV and STAGE projects
* 2 Tekton pipelines for deploying application to DEV and promoting to STAGE environments
* Gogs git server (username/password: `gogs`/`gogs`)
* Sonatype Nexus (username/password: `admin`/`admin123`)
* SonarQube (username/password: `admin`/`admin`)
* Report repository for test and project generated reports
* Imports [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) repository into Gogs git server
* Adds a webhook to `spring-petclinic` repository in Gogs to start the Tekton pipeline

## About Tekton

## About this Lab

### Deploy DEV Pipeline Steps

On every push to the `spring-petclinic` git repository on Gogs git server, the following steps are executed within the DEV pipeline:

1. Code is cloned from Gogs git server and the unit-tests are run
1. Unit tests are executed and in parallel the code is analyzed by SonarQube for anti-patterns, and a dependency report is generated
1. Application is packaged as a JAR and released to Sonatype Nexus snapshot repository
1. A container image is built in DEV environment using S2I, and pushed to OpenShift internal registry, and tagged with `spring-petclinic:[branch]-[commit-sha]` and `spring-petclinic:latest`
1. Kubernetes manifests and performance tests configurations are cloned from Git repository
1. Application is deployed into the DEV environment using `kustomize`, the DEV manifests from Git, and the application `[branch]-[commit-sha]` image tag built in previous steps
1. Integrations tests and Gatling performance tests are executed in parallel against the DEV environment and the results are uploaded to the report server

![Pipeline Diagram](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/pipeline-diagram-dev.svg)

### Deploy STAGE Pipeline Steps

The STAGE deploy pipeline requires the image tag that you want to deploy into STAGE environment. The following steps take place within the STAGE pipeline:
1. Kubernetes manifests are cloned from Git repository
1. Application is deployed into the STAGE environment using `kustomize`, the STAGE manifests from Git, and the application `[branch]-[commit-sha]` image tag built in previous steps. Alternatively you can deploy the `latest` tag of the application image for demo purposes.
1. In parallel, tests are cloned from Git repository
1. Tests are executed against the staging environment

![Pipeline Diagram](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/pipeline-diagram-stage.svg)

## Running this Lab

Navigate to the directory:
```
cd tekton/tekton-cd-demo
```

Deploy the demo and wait for the components to be in READY state. Workloads will typically be deployed in the `demo-cicd` namespace.:
```
$ demo.sh install
```

Navigate to the gogs server in the output of the script, or navigate to Networking > Routes > gogs and sign in as username/pass: `gogs/gogs`:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton1.png)
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton2.png)

To kick off the pipeline, make a commit to the repo. A simple example would be to just add a random entry to the gogs/spring-petclinic README.md such as `foo`:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton3.png)

Once the edit is committed and pushed, you should see the pipeline kick off. Navigate to the OCP Console > Pipelines:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton4.png)

Here you can drill down into specific Pipeline Run Details such as the YAML manifests:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton5.png)

You can also see the Logs of each specific task in the pipeline:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton6.png)

### Checking the pipeline run log through CLI
You can do this by running the command:
```
$ tkn pipeline logs petclinic-deploy-dev -f NAMESPACE
```

### Navigate to the Pet Clinic UI
In the OpenShift Console, using the `demo-dev` Namespace, navigate to the Spring Pet Clinic UI by clicking on Networking > Routes > spring-petclinic:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton7.png)

Here you should see the default Pet Clinic UI has been deployed:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton8.png)

## Making a real change to the app
To demonstrate a real example, we will change the background color of the Pet Clinic app and watch as our commit moves through the pipeline and is deployed into the `demo-dev` namespace. From there we will promote the change to our Staging branch

In the spring-petclinic git repo, navigate to the `src/main/less/petclinic.less` directory:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton9.png)

Make a change to the `@body-bg:` color. In this example we will use `spring-green`. Finish by committing your changes:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton10.png)

In the OCP Console, you should see that a new PipelineRun has been kicked off because of our commit:
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton11.png)

Once the Pipeline is complete, refresh the Pet Clinic app UI and you should see a change in background color from light grey to green if everything has completed successfully. Note that this may take a few minutes
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton12.png)

### Promoting to Stage
To promote the pipeline to the `demo-stage` namespace, navigate to the Pipelines tab and start the `petclinic-deploy-stage` pipeline
![](https://github.com/ably77/openshift-testbed/blob/master/resources/labs/tekton13.png)