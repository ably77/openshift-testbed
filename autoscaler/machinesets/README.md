# Creating a new machineset

Taking a look at `templates/machineset.yaml` you will see that the example is simply a template for creating a new machine set. For this example we will be generating kustomize patches in order to layer over this template to create a real working machineset.

### Change varaibles in the vars.txt
```
# name of your machineset
MACHINESET_NAME="demo-machineset"

# roles of your machine set 
ROLE="worker"
SECOND_ROLE="stateful"

# region and zone to deploy workers in
REGION="us-west-1"
ZONE="b"

# instance type to deploy
INSTANCE_TYPE="m5.xlarge"

# desired number of workers
DESIRED_REPLICAS="1"
```

### Run this script
```
./runme.sh
```
