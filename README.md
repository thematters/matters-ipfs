Repo for tools in ipfs cluster orchestration and content pinning.

# Notes

Manually generating shared secret:

```
export CLUSTER_SECRET=$(od  -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
```

ipfs path: ~/.ipfs/
ipfs-cluster-service path: ~/.ipfs-cluster

## Current multiaddresses
