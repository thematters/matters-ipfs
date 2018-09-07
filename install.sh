#!/usr/bin/env bash

# firt set CLUSTER_SECRET in the first node:
# export CLUSTER_SECRET=$(od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
# other nodes must use the same secret:
# echo $CLUSTER_SECRET
# current secret: 0352322f72d19b0827bd76923c225199e9c2da84847601fc33803d84894b3b78

set -e

[ -z "$CLUSTER_SECRET" ] && echo "Need to set CLUSTER_SECRET" && exit 1;

echo 'export IPFS_PATH=/data/ipfs' >>~/.bash_profile
echo 'export IPFS_CLUSTER_PATH=/data/ipfs-cluster' >>~/.bash_profile
source ~/.bash_profile

# install ipfs daemon
wget https://dist.ipfs.io/go-ipfs/v0.4.17/go-ipfs_v0.4.17_linux-amd64.tar.gz
tar xvfz go-ipfs_*.tar.gz
rm go-ipfs_*.tar.gz
sudo mv go-ipfs/ipfs /usr/local/bin
rm -rf go-ipfs

# install ipfs cluster service
wget https://dist.ipfs.io/ipfs-cluster-service/v0.5.0/ipfs-cluster-service_v0.5.0_linux-amd64.tar.gz
tar xvfz ipfs-cluster-service_*.tar.gz
rm ipfs-cluster-service_*.tar.gz
sudo mv ipfs-cluster-service/ipfs-cluster-service /usr/local/bin
rm -rf ipfs-cluster-service

# install ipfs cluster ctl, only needed for control node
wget https://dist.ipfs.io/ipfs-cluster-ctl/v0.5.0/ipfs-cluster-ctl_v0.5.0_linux-amd64.tar.gz
tar xvfz ipfs-cluster-ctl_*.tar.gz
rm ipfs-cluster-ctl_*.tar.gz
sudo mv ipfs-cluster-ctl/ipfs-cluster-ctl /usr/local/bin
rm -rf ipfs-cluster-ctl

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
if [ ! -z "$CLUSTER_BOOTSTRAP" ]; then
  sed -i -e "s;\"bootstrap\": \[\];\"bootstrap\": [\"${CLUSTER_BOOTSTRAP}\"];" "${IPFS_CLUSTER_PATH}/service.json"
fi
sed -i -e 's;127\.0\.0\.1/tcp/9095;0.0.0.0/tcp/9095;' "${IPFS_CLUSTER_PATH}/service.json"