# Install dex

Create certificate:
```
./gencert.sh
kubectl create -f dex-ns.yaml
kubectl create secret tls dex.newtech.academy.tls -n dex --cert=ssl/cert.pem --key=ssl/key.pem
sudo cp ssl/ca.pem /etc/kubernetes/pki/openid-ca.pem
```

Create secret:
```
kubectl create secret \
    generic github-client \
    -n dex \
    --from-literal=client-id=$GITHUB_CLIENT_ID \
    --from-literal=client-secret=$GITHUB_CLIENT_SECRET
```

kube-apiserver manifest file changes ( /etc/kubernetes/manifests/kube-apiserver.yaml):
```
    - --oidc-issuer-url=https://dex.newtech.academy:32000
    - --oidc-client-id=example-app
    - --oidc-ca-file=/etc/kubernetes/pki/openid-ca.pem
    - --oidc-username-claim=email
    - --oidc-groups-claim=groups
```

deploy:
```
kubectl create -f dex.yaml
```

deploy example app:
```
sudo apt-get install make golang-1.9
git clone https://github.com/coreos/dex.git
cd dex
git checkout v2.10.0
export PATH=$PATH:/usr/lib/go-1.9/bin
go get github.com/coreos/dex
make bin/example-app
export MY_IP=$(curl -s ifconfig.co)
./bin/example-app --issuer https://dex.newtech.academy:32000 --issuer-root-ca /etc/kubernetes/pki/openid-ca.pem --listen http://${MY_IP}:5555 --redirect-uri http://${MY_IP}:5555/callback
```

# Add user:
```
kubectl create -f user.yaml
#kubectl config set-credentials developer --token ${TOKEN}
kubectl config set-credentials developer --auth-provider=oidc --auth-provider-arg=idp-issuer-url=https://dex.newtech.academy:32000 --auth-provider-arg=client-id=example-app --auth-provider-arg=idp-certificate-authority=/etc/kubernetes/pki/openid-ca.pem  --auth-provider-arg=id-token=${TOKEN}
kubectl config set-context dev-default --cluster=kubernetes --namespace=default --user=developer
kubectl config use-context dev-default
```

# Auto-renewal of token
For autorenewal, you need to share the client secret with the end-user (not recommended)
```
kubectl config set-credentials developer --auth-provider=oidc --auth-provider-arg=idp-issuer-url=https://dex.newtech.academy:32000 --auth-provider-arg=client-id=example-app --auth-provider-arg=idp-certificate-authority=/etc/kubernetes/pki/openid-ca.pem  --auth-provider-arg=id-token=${TOKEN} --auth-provider-arg=refresh-token=${REFRESH_TOKEN} --auth-provider-arg=client-secret=${CLIENT_SECRET}
```

# LDAP config

```
sudo apt-get -y install slapd ldap-utils gnutls-bin ssl-cert
sudo dpkg-reconfigure slapd
./gencert-ldap.sh
sudo ldapmodify -H ldapi:// -Y EXTERNAL -f ldap/certinfo.ldif
ldapadd -x -D cn=admin,dc=example,dc=com -W -f ldap/users.ldif 
```

Edit (with sudo) /etc/default/slapd
```
SLAPD_SERVICES="ldap:/// ldapi:/// ldaps:///"
```
and run:

```
sudo systemctl restart slapd.service
```

create LDAP CA secret and change configmap
```
cat /etc/ssl/certs/cacert.pem
kubectl edit configmap ldap-tls -n dex
kubectl apply -f configmap-ldap.yaml
kubectl edit deploy dex -n dex  # edit the ldap IP alias
```


