#!/bin/bash

# All logs stored at /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log
# Hook specific logs stored at /opt/codedeploy-agent/deployment-root/deployment-logs/before_install.log

LOGFILE=/opt/codedeploy-agent/deployment-root/deployment-logs/before_install.log
exec 1> >(gawk '{ print strftime("[%Y-%m-%d %H:%M:%S %Z]"), $0 }' > $LOGFILE) 2>&1
set -o xtrace

systemctl stop myapp
systemctl disable myapp

rm -rf /tmp/app/*

env > /tmp/env.txt

mkdir -p /srv/app/current/
AWS_DEFAULT_REGION='us-east-2' aws deploy get-deployment \
    --deployment-id $DEPLOYMENT_ID  \
    --query "deploymentInfo.revision.gitHubLocation.commitId" \
    --output text \
> /srv/app/current/REVISION
