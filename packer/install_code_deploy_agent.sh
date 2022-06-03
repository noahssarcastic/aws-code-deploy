#!/bin/bash

BUCKET_NAME='aws-codedeploy-us-east-2'
REGION='us-east-2'
# VERSION='xxx'

# Install dependencies
sudo yum update -y
sudo yum install -y ruby wget

# Clean any previous agent caching information
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
sudo yum erase codedeploy-agent -y

# Download the agent code
cd /home/ec2-user
wget https://$BUCKET_NAME.s3.$REGION.amazonaws.com/latest/install
chmod +x ./install

# Install the latest version
sudo ./install auto

# Install a specific version
# sudo ./install auto -v releases/codedeploy-agent-$VERSION.rpm

sudo service codedeploy-agent start
