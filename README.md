Repo for tools in ipfs cluster orchestration and content pinning.

# Notes

Manually generating shared secret:

```
export CLUSTER_SECRET=$(od  -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')
```

ipfs path: /data/ipfs
ipfs-cluster-service path: /data/ipfs-cluster

## Current node 0 multiaddress

/ip4/13.251.59.100/tcp/9096/ipfs/Qmdji8g2PDkbXzrux75pHijXWVsEh5C4tmwqGVgrdXXW2n
