# Rook

Note: When creating kubernetes nodes, ensure you have one or more free devices to use. When using DigitalOcean, you can add an unformatted volume to each node droplet.

Examples from https://github.com/rook/rook/tree/master/cluster/examples/kubernetes

Install rook:
```
kubectl create -f https://raw.githubusercontent.com/rook/rook/v1.12.2/deploy/examples/crds.yaml
kubectl create -f https://raw.githubusercontent.com/rook/rook/v1.12.2/deploy/examples/common.yaml
kubectl create -f https://raw.githubusercontent.com/rook/rook/v1.12.2/deploy/examples/operator.yaml
kubectl create -f rook-cluster.yaml
```

Storage:
```
kubectl create -f rook-storageclass.yaml
```

Rook tools:
```
kubectl create -f rook-tools.yaml
```
Note: use ceph status instead of rookctl status

MySQL demo:
```
kubectl create -f mysql-demo.yaml
```

# object storage

Create object storage:
```
kubectl create -f 
```

Create user:
```
radosgw-admin user create --uid rook-user --display-name "A rook rgw User" --rgw-realm=my-store --rgw-zonegroup=my-store
```

Export variables
```
export AWS_HOST=
export AWS_ENDPOINT=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
