# Network policy

```
kubectl create -f nginx.yml
kubectl create -f networkpolicy-isolation.yml
kubectl create -f networkpolicy-nginx.yml
```

```
kubectl run -it --rm -l app=access-nginx --image busybox busybox
```
