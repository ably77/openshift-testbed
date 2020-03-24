#!/bin/bash

GITHUB_USERNAME=ably77

oc delete -f fullpipeline.yaml

oc delete project airlineprediction-generator-dev
oc delete project airlineprediction-generator-staging
oc delete project ${GITHUB_USERNAME}-cicd-environment
