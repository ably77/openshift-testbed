#!/bin/bash

# Run build pipeline
tkn -n basic-spring-boot-build pipeline start basic-spring-boot-pipeline -r basic-spring-boot-git=basic-spring-boot-git -s tekton

# Check logs

tkn pipelinerun logs -f
