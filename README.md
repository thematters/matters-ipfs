Matters IPFS 集群及 gateway 設定。

# 启动集群

安裝：

```
bash install.sh
```

## 第二个及之后节点

IPFS 集群節點需要共享同一個 `CLUSTER_SECRET` ，目前為 `0352322f72d19b0827bd76923c225199e9c2da84847601fc33803d84894b3b78`。設定為環境變量：

```
export CLUSTER_SECRET=0352322f72d19b0827bd76923c225199e9c2da84847601fc33803d84894b3b78
```

設定 `CLUSTER_BOOTSTRAP` 變量，指向第一個節點，目前為 `/ip4/13.251.59.100/tcp/9096/ipfs/QmPCnY9KQK2d623zpkezMofUqZ4Ji2VwxpthPBENyuNT52`:

```
export CLUSTER_BOOTSTRAP=/ip4/13.251.59.100/tcp/9096/ipfs/QmPCnY9KQK2d623zpkezMofUqZ4Ji2VwxpthPBENyuNT52
```

然後啟動 ipfs 以及 ipfs-cluster-service：

```
bash initialize.sh
```

ipfs 路徑為 `/data/ipfs` , cluster 路徑為 `/data/ipfs-cluster`。

## 第一个节点

第一个节点可以設定新的 `CLUSTER_SECRET` ，再讓其他節點共用該值：

```
export CLUSTER_SECRET=$(od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
echo $CLUSTER_SECRET
```

第一個節點不需要設定 `CLUSTER_BOOTSTRAP` ，其他啟動方式同上。啟動后通過 `cat $IPFS_CLUSTER_PATH/service.json` 查看配置信息中 `cluster/id` 和 `cluster/listen_multiaddress` , 將 `listen_multiaddress` 中的 `0.0.0.0` 替換為 public ip、加上 `id` 則為新的 `CLUSTER_BOOTSTRAP` 變量。

如果需要開放 gateway，則執行：
`ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080`

# 常用命令

查看狀態：

```
sudo systemctl status ipfs
sudo systemctl status ipfs-cluster
```

查看日誌：

```
journalctl -u ipfs --follow
journalctl -u ipfs-cluster --follow
```

查看链接节点：

```
ipfs-cluster-ctl peers ls
```

# gateway 端口

tcp 8080 作為 gateway，4001 / 8081(websocket) 作為 swarm 端口，9096 作為集群節點之間通訊端口。

gateway 使用 nginx 作為負載均衡，同時利用 nginx 將 port 4002 映射到 port 8081 以便支持 https 加密鏈接（ipfs 目前不直接支持加密鏈接）。nginx 配置見 `nginx.config`。

# TODO

- 節點數量足夠之後設定合適的 `replication_factor_min` 和 `replication_factor_max`。

# 參考

## IPFS

https://forum.qtum.org/topic/87/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8%E6%98%9F%E9%99%85%E6%96%87%E4%BB%B6%E4%BC%A0%E8%BE%93%E7%BD%91%E7%BB%9C-ipfs-%E6%90%AD%E5%BB%BA%E5%8C%BA%E5%9D%97%E9%93%BE%E6%9C%8D%E5%8A%A1-%E4%B8%80

## IPFS 集群建立

https://medium.com/textileio/tutorial-setting-up-an-ipfs-peer-part-ii-67a99cd2c5

https://rklaehn.github.io/2018/06/08/running-ipfs-gateway/
