#!/bin/bash

rm -rf /tmp/app/*

cat << EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My app

[Service]
ExecStart=node /tmp/app/index.js
Restart=always
User=nobody
# Note Debian/Ubuntu uses 'nogroup', RHEL/Fedora uses 'nobody'
Group=nobody
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/tmp/app/index.js

[Install]
WantedBy=multi-user.target
EOF

systemctl enable myapp
