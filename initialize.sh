#!/usr/bin/env bash

set -e

[ -z "$CLUSTER_SECRET" ] && echo "Need to set CLUSTER_SECRET" && exit 1;

echo 'export IPFS_PATH=/data/ipfs' >>~/.bash_profile
echo 'export IPFS_CLUSTER_PATH=/data/ipfs-cluster' >>~/.bash_profile
source ~/.bash_profile

# init ipfs
sudo mkdir -p $IPFS_PATH
sudo chown ubuntu:ubuntu $IPFS_PATH
ipfs init -p server
ipfs config Datastore.StorageMax 100GB
# uncomment if you want direct access to the instance's gateway
#ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

# init ipfs-cluster-service
sudo mkdir -p $IPFS_CLUSTER_PATH
sudo chown ubuntu:ubuntu $IPFS_CLUSTER_PATH
ipfs-cluster-service init
if [ ! -z "$CLUSTER_BOOTSTRAP" ]; then
  sed -i -e "s;\"bootstrap\": \[\];\"bootstrap\": [\"${CLUSTER_BOOTSTRAP}\"];" "${IPFS_CLUSTER_PATH}/service.json"
fi
sed -i -e 's;127\.0\.0\.1/tcp/9095;0.0.0.0/tcp/9095;' "${IPFS_CLUSTER_PATH}/service.json"

# ipfs systemctl service
sudo bash -c 'cat >/lib/systemd/system/ipfs.service <<EOL
[Unit]
Description=ipfs daemon
[Service]
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
Restart=always
User=ubuntu
Group=ubuntu
Environment="IPFS_PATH=/data/ipfs"
[Install]
WantedBy=multi-user.target
EOL'

# ipfs-cluster systemctl service
sudo bash -c 'cat >/lib/systemd/system/ipfs-cluster.service <<EOL
[Unit]
Description=ipfs-cluster-service daemon
Requires=ipfs.service
After=ipfs.service
[Service]
ExecStart=/usr/local/bin/ipfs-cluster-service daemon
Restart=always
User=ubuntu
Group=ubuntu
Environment="IPFS_CLUSTER_PATH=/data/ipfs-cluster"
[Install]
WantedBy=multi-user.target
EOL'

# enable the new services
sudo systemctl daemon-reload
sudo systemctl enable ipfs.service
sudo systemctl enable ipfs-cluster.service

# start the ipfs-cluster-service daemon (the ipfs daemon will be started first)
sudo systemctl start ipfs-cluster