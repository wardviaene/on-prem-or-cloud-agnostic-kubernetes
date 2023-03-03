#!/bin/bash
echo "This script has been tested on ubuntu 20.4.3 LTS (focal) and ubuntu 22.04.1 LTS (jammy). If you are using another distribution, you most likely need to edit this script."
sleep 3

echo "installing docker"
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install docker-ce docker-ce-cli containerd.io -y

echo "installing kubeadm and kubectl"
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

# containerd config to work with Kubernetes >=1.26
echo "SystemdCgroup = true" > /etc/containerd/config.toml
systemctl restart containerd

echo "You can now execute the kubeadm join command (the command is shown during kubeadm init on the master node)"
