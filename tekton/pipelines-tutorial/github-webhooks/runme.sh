#!/bin/bash

oc create -f github-webhooks/wh-create-webhook-user.yaml

oc create -f github-webhooks/wh-webhook-secret.yaml

oc create -f github-webhooks/wh-create-webhook-task.yaml

oc create -f github-webhooks/wh-create-api-repo-webhook-run.yaml

oc create -f github-webhooks/wh-create-ui-repo-webhook-run.yaml
