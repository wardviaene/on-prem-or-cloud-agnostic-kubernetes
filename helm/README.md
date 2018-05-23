# install helm

You can download the latest release from https://github.com/kubernetes/helm/releases or enter the following command to install helm locally:

```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
```

# init helm

```
helm init --service-account tiller
```
