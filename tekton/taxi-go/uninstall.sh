#!/bin/bash

GITHUB_USER=ably77

oc delete project ${GITHUB_USER}-dev-environment
oc delete project ${GITHUB_USER}-stage-environment
oc delete project ${GITHUB_USER}-cicd-environment
