#!/bin/bash

NODE_PROCESS=$(lsof -t -i:3000)
if $NODE_PROCESS; then kill $NODE_PROCESS; fi
