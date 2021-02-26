# Adding nodes to OpenShift with MachineSets

## About MachineSets
You can create a different MachineSet to serve a specific purpose in your OpenShift Container Platform cluster. For example, you might create dedicated infrastructure MachineSets to run non-subscription workloads such as OpenShift Logging, Openshift Container Storage, or Quay.

MachineSet resources are groups of machines. Machine sets are to machines as replica sets are to pods. If you need more machines or must scale them down, you change the replicas field on the machine set to meet your compute need.

## About this Lab
An example template and script for creating MachineSets is provided in the `autoscaler/machinesets` directory. This lab will walk you through creating and deploying a new MachineSet on OpenShift.

**NOTE:** While the structure of the MachineSet YAML as well as the process of deploying the MachineSet are the same for all platforms, this lab is written to work on AWS. For other platforms you would have to modify the template in `autoscaler/machinesets/templates/machineset.yaml` and the provided `vars.txt` example in order to work properly.

## Lab:

Navigate to the `autoscaler/machinesets` directory:
```
cd autoscaler/machinesets
```

### Setting up an Infra MachineSet
Infrastructure MachineSets are handy for deploying workloads on the OpenShift Platform that do not require an underlying OpenShift subscription in order to run. These workloads include OpenShift Logging, Internal Registry, Quay Enterprise (although a Quay Enterprise subscription will be required), OpenShift Container Storage (although an OCS subscription will be required), and a few others.

Modify the `infra-vars.txt` example to your desired parameters:
```
# name of your machineset
MACHINESET_NAME="infra-machineset"

# roles of your machine set 
ROLE="infra"
SECOND_ROLE="logging"

# region and zone to deploy workers in
REGION="us-west-1"
ZONE="b"

# instance type to deploy
INSTANCE_TYPE="m4.2xlarge"

# desired number of workers
DESIRED_REPLICAS="2"
```

Run the script to create your infra MachineSet:
```
./runme.sh
```

The script will prompt for the pathway to the variable parameters and generate a MachineSet in the `/generated` directory. It will also prompt the user whether they want to deploy the created MachineSet after a dry run. Example output below:
```
% ./runme.sh 
Name of variables file (i.e. vars.txt): infra-vars.txt
generated machineset in directory generated/infra-machineset
now doing a dry run of the generated machineset..

testing the generated manifests using --dry-run

machineset.machine.openshift.io/1-ly-demo-vdvdh-infra-us-east-1b created (dry run)

Select 'y' to deploy the machineset:yes
machineset.machine.openshift.io/1-ly-demo-vdvdh-infra-us-east-1b created
```

### Setting up an OCS MachineSet
A second example OCS MachineSet can also be created by providing inputs in the ocs-vars.txt. Just re-run the script and provide the correct path to the OCS variables file
```
% ./runme.sh
Name of variables file (i.e. vars.txt): ocs-vars.txt
generated machineset in directory generated/ocs-machineset-1a
now doing a dry run of the generated machineset..

testing the generated manifests using --dry-run

machineset.machine.openshift.io/1-ly-demo-vdvdh-ocs-us-east-1a created (dry run)

Select 'y' to deploy the machineset:yes
machineset.machine.openshift.io/1-ly-demo-vdvdh-ocs-us-east-1a created
```
