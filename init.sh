#!/usr/bin/env bash

# firt set CLUSTER_SECRET in the first node:
# export CLUSTER_SECRET=$(od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
# other nodes must use the same secret:
# echo $CLUSTER_SECRET
# current secret: export CLUSTER_SECRET=0352322f72d19b0827bd76923c225199e9c2da84847601fc33803d84894b3b78

set -e

[ -z "$CLUSTER_SECRET" ] && echo "Need to set CLUSTER_SECRET" && exit 1;

echo 'export IPFS_PATH=/data/ipfs' >>~/.bash_profile
echo 'export IPFS_CLUSTER_PATH=/data/ipfs-cluster' >>~/.bash_profile
source ~/.bash_profile

# init ipfs
sudo mkdir -p $IPFS_PATH
sudo chown ubuntu:ubuntu $IPFS_PATH
ipfs init -p server
# ipfs config Datastore.StorageMax 100GB
# uncomment if you want direct access to the instance's gateway
# ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

# init ipfs-cluster-service
sudo mkdir -p $IPFS_CLUSTER_PATH
sudo chown ubuntu:ubuntu $IPFS_CLUSTER_PATH
ipfs-cluster-service init

# move service files
sudo mv ipfs.service /lib/systemd/system/ipfs.service
sudo mv ipfs-cluster.service /lib/systemd/system/ipfs-cluster.service
