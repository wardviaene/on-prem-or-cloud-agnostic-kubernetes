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
helm repo add jetstack https://charts.jetstack.io
```

```
helm repo update
```

```
helm install  --name cert-manager --namespace cert-manager jetstack/cert-manager
```
