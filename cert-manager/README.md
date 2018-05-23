# install nginx ingress

```
helm install stable/nginx-ingress
```

# install cert-manager

```
helm install \
    --name cert-manager \
    --namespace kube-system \
    stable/cert-manager
```
