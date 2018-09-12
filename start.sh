#!/usr/bin/env bash

# start ipfs 

# ipfs daemon --enable-gc & 
# ipfs-cluster-service daemon

# enable the new services
sudo systemctl daemon-reload
sudo systemctl enable ipfs.service
sudo systemctl enable ipfs-cluster.service

# start the ipfs-cluster-service daemon
sudo systemctl start ipfs
sudo systemctl start ipfs-cluster