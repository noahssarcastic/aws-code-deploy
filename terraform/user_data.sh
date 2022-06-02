#!/bin/bash

# Redirect script output to ec2 logs.
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Start the node app.
(cd /tmp/app && node index.js)
