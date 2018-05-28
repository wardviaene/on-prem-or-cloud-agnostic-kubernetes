# istio install

install:
```
curl -L https://git.io/getLatestIstio | sh -
echo 'export PATH="$PATH:/home/ubuntu/istio-0.7.1/bin"' >> ~/.profile
```

with no matual TLS authentication
```
kubectl apply -f install/kubernetes/istio.yaml
```

or with mutual TLS authentication
```
kubectl apply -f install/kubernetes/istio-auth.yaml
```

Example app (from istio)
```
kubectl edit svc istio-ingress -n istio-system # change loadbalancer to nodeport (or use hostport)
export PATH="$PATH:/home/ubuntu/istio-0.7.1/bin"
kubectl apply -f <(istioctl kube-inject --debug -f samples/bookinfo/kube/bookinfo.yaml)
```


# Traffic management

Add default route to v1:
```
istioctl create -f samples/bookinfo/routing/route-rule-all-v1.yaml
```

Route all traffic to v2
```
istioctl create -f samples/bookinfo/routing/route-rule-reviews-test-v2.yaml
```

Route 50% of traffic between v1 and v3:
```
istioctl replace -f samples/bookinfo/routing/route-rule-reviews-50-v3.yaml
```

# Distributed tracing

Enable zipkin:
```
kubectl apply -f install/kubernetes/addons/zipkin.yaml
```

Enable Jaeger:
```
kubectl delete -f install/kubernetes/addons/zipkin.yaml # if zipkin was installed, delete it first
kubectl apply -n istio-system -f https://raw.githubusercontent.com/jaegertracing/jaeger-kubernetes/master/all-in-one/jaeger-all-in-one-template.yml

```


