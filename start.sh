#!/usr/bin/env bash

# start ipfs 

ipfs daemon --enable-gc & 
ipfs-cluster-service daemon