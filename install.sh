#!/usr/bin/env bash

# install ipfs daemon
wget https://dist.ipfs.io/go-ipfs/v0.4.17/go-ipfs_v0.4.17_linux-amd64.tar.gz
tar xvfz go-ipfs_*.tar.gz
rm go-ipfs_*.tar.gz
sudo mv go-ipfs/ipfs /usr/local/bin
rm -rf go-ipfs

# install ipfs cluster service
# wget https://dist.ipfs.io/ipfs-cluster-service/v0.5.0/ipfs-cluster-service_v0.5.0_linux-amd64.tar.gz
# tar xvfz ipfs-cluster-service_*.tar.gz
# rm ipfs-cluster-service_*.tar.gz
# sudo mv ipfs-cluster-service/ipfs-cluster-service /usr/local/bin
# rm -rf ipfs-cluster-service

# # install ipfs cluster ctl, only needed for control node
# wget https://dist.ipfs.io/ipfs-cluster-ctl/v0.5.0/ipfs-cluster-ctl_v0.5.0_linux-amd64.tar.gz
# tar xvfz ipfs-cluster-ctl_*.tar.gz
# rm ipfs-cluster-ctl_*.tar.gz
# sudo mv ipfs-cluster-ctl/ipfs-cluster-ctl /usr/local/bin
# rm -rf ipfs-cluster-ctl
