#!/bin/bash

kill $(lsof -t -i:3000)
rm -r /tmp/app/*
