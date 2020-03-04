# Basic Springboot Tekton Pipeline

This example runs through a basic hello-world springboot app example using Tekton pipelines for CI/CD

## Prerequisites
- OCP 4.x Cluster
- Tekton Pipelines Installed
- Access to GitHub
- Tekton CLI

## Architecture

The following breaks down the architecture of the pipeline deployed, as well as walks through the manual deployment steps

### OpenShift Templates

The components of this pipeline are divided into two templates.

The first template, `build.yml` is what we are calling the "Build" template. It contains:

* A Tekton pipeline and associated objects
* An `s2i` BuildConfig
* An ImageStream for the s2i build config to push to

The build template contains a default source code repo for a [java application](https://github.com/redhat-cop/spring-rest) compatible with this pipelines architecture .

The second template, `deployment.yml` is the "Deploy" template. It contains:

* A tomcat8 DeploymentConfig
* A Service definition
* A Route

The idea behind the split between the templates is that in the future I can deploy the build template only once (to my build project) and that the pipeline will promote my image through all of the various stages of my application's lifecycle (i.e. build --> dev --> stage --> prod)

### Pipeline Script

This project includes a sample `Tekton` pipeline script that could be included with a Java project in order to implement a basic CI/CD pipeline for that project, under the following assumptions:

* The project is built with Maven
* The OpenShift projects that represent the Application's lifecycle stages are of the naming format: `<app-name>-dev`, `<app-name>-stage`, `<app-name>-prod`.

This pipeline defaults to use our [Spring Boot Demo App](https://github.com/redhat-cop/spring-rest).

## Running the demo

To instantiate the pipeline:
```
./deploy_pipeline.sh
```

To run pipeline:
```
./run_pipeline.sh
```

Note: To re-run pipeline, simply re-run the `./run_pipeline.sh` script. This will initiate a new build, and will do a rolling update over the existing deployment

To access app route:
```
oc get routes -n basic-springboot-build
```

### Uninstall
To uninstall just simply delete the project namespace
```
./uninstall.sh
```
