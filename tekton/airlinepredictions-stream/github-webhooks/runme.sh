#!/bin/bash

oc create -f github-webhooks/wh-create-webhook-user.yaml

oc create -f github-webhooks/wh-webhook-secret.yaml

oc create -f github-webhooks/wh-create-webhook-task.yaml

oc create -f github-webhooks/wh-create-spring-repo-webhook-run.yaml
