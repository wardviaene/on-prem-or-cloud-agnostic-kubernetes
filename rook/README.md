# Rook

Examples from https://github.com/rook/rook/tree/master/cluster/examples/kubernetes

Install rook:
```
kubectl create -f rook-operator.yaml
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
