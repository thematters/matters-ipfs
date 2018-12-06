Matters IPFS scripts.

installation:

```
bash install.sh
```

start:

```
bash initialize.sh
```

status:

```
sudo systemctl status ipfs
```

logs:

```
journalctl -u ipfs --follow
journalctl -u ipfs-cluster --follow
```

check peer connections:

```
ipfs-cluster-ctl peers ls
```
