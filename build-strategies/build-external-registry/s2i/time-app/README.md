
# Introduction
Follow the steps below to demonstrate use of an external registry (Docker Hub in this example) rather than the internal OCP registry as the end output of a Openshift Build process

# create new project
```
oc new-project snow
```

# create a dockerhub secret
oc create secret docker-registry dockerhub --docker-username="<username>" --docker-password="<access token>" --docker-email="<email>" --docker-server="docker.io"

# create example 'time' app buildConfig
oc create -f buildconfig.yaml

## take note
The `output:` section in the buildConfig is pointed to an external registry, in my case public DockerHub. A build should automatically initiate
```
output:
  to:
    kind: DockerImage
    name: 'docker.io/ably77/python-lyapp:latest'
  pushSecret:
    name: dockerhub
```

# deploy an ImageStream associated with the external registry image
oc create -f imagestream.yaml

## take note
The `from:` section in the imageStream is pointed to an external registry
```
from:
  kind: DockerImage
  name: 'docker.io/ably77/python-lyapp:latest'
```

## Configuring periodic importing of imagestreamtags
https://docs.openshift.com/container-platform/4.4/openshift_images/image-streams-manage.html#images-imagestreams-import_image-streams-managing
When working with an external container image registry, it is necessary to periodically re-import an image to maintain consistency between the external and internal Openshift registry, using the --scheduled flag. The example here sets this value to `scheduled: true` in the `imagestream.yaml`

NOTE: By default, the scheduled importPolicy is set to recur every 15 minutes, therefore you may expect to see a delay in the deploy process after a new build is completed
```
importPolicy:
  scheduled: true
```

Optionally, you can set periodic import of imagestreamtag using the the `oc` CLI using tags
```
oc tag docker.io/ably77/python-lyapp:latest python-lyapp:latest --scheduled
```

Remove the periodic check, re-run above command but omit the --scheduled flag. This will reset its behavior to default.
```
oc tag <repositiory/image> <image-name:tag>
```

# create a DeploymentConfig from ImageStream

To automatically create a DeploymentConfig from your ImageStream you can use the `oc` CLI, the example `dc.yaml` is also included as a reference:
```
oc new-app <dockerimage>:<tag> --name <imagestream>
```
oc new-app python-lyapp:latest --name python-lyapp
```

Taking a look at the `triggers:` section, you will see that a deployment update will be triggered on an ImageStream change event
```
triggers:
  - type: ConfigChange
  - type: ImageChange
```
