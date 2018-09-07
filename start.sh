#!/usr/bin/env bash

# start ipfs with systemctl
# get log with: journalctl -u ipfs-cluster -n10

# ipfs systemctl service
sudo bash -c 'cat >/lib/systemd/system/ipfs.service <<EOL
[Unit]
Description=ipfs daemon
[Service]
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
Restart=always
User=ec2-user
Group=ec2-user
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
User=ec2-user
Group=ec2-user
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

# see the logs
journalctl -u ipfs-cluster -n10