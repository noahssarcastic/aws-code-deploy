#!/bin/bash

systemctl stop myapp
systemctl disable myapp

rm -rf /tmp/app/*
