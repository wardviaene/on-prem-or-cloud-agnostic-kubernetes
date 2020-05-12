# install nginx ingress

```
helm install --name my-ingress stable/nginx-ingress \
  --set controller.kind=DaemonSet \
  --set controller.service.type=NodePort \
  --set controller.hostNetwork=true
```

# start myapp

Create myapp and add an ingress rule:

```
kubectl create -f myapp.yml
kubectl create -f myapp-ingress.yml
```

# install cert-manager

```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.0/cert-manager.crds.yaml
```
