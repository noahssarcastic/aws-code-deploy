#!/bin/bash

kill $(lsof -t -i:3000)
rm /tmp/app/*
