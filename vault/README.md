# Vault

## deploy etcd operator
```
kubectl create -f etcd-rbac.yaml 
kubectl create -f etcd_crds.yaml
kubectl create -f etcd-operator-deploy.yaml
```

## deploy vault operator
```
kubectl create -f vault-rbac.yaml 
kubectl create -f vault_crd.yaml
kubectl create -f vault-deployment.yaml
```

## deploy vault + etcd cluster
```
kubectl create -f example_vault.yaml
```

## install vault cli
```
wget https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip
sudo apt-get -y install unzip
unzip vault_0.10.1_linux_amd64.zip
chmod +x vault
sudo mv vault /usr/local/bin
```
## Initialize Vault cluster
```
kubectl get vault example -o jsonpath='{.status.vaultStatus.sealed[0]}' | xargs -0 -I {} kubectl -n default port-forward {} 8200
export VAULT_ADDR='https://localhost:8200'
export VAULT_SKIP_VERIFY="true"
vault status
vault operator init
vault operator unseal
vault operator unseal
vault operator unseal
vault login <key>
```

## Write a secret
```
kubectl -n default get vault example -o jsonpath='{.status.vaultStatus.active}' | xargs -0 -I {} kubectl -n default port-forward {} 8200
vault write secret/myapp/mypassword value=pass123
vault write sys/policy/my-policy policy=@policy.hcl
vault token create -policy=my-policy

```

## read a secret in a pod
```
kubectl run --image ubuntu -it --rm ubuntu
apt-get update && apt-get -y install curl
curl -k -H 'X-Vault-Token: <token>' https://example:8200/v1/secret/myapp/mypassword
```
