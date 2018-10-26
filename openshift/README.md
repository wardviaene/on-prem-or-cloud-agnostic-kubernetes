# Install Docker
```
yum -y install docker
systemctl enable docker
systemctl start docker
```

# set insecure registry
```
echo '{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}' > /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker
```


# install oc, cluster up
```
curl -o ~/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz -L https://github.com/openshift/origin/releases/download/v3.9.0/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz
cd ~
tar -xzvf openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz
export PATH=$PATH:~/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit
echo 'export PATH=$PATH:~/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit' >> .bash_profile
oc cluster up --public-hostname=$(curl -s ifconfig.co) --host-data-dir=/data
```
