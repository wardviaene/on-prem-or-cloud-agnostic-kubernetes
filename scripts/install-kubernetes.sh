#!/bin/bash

echo "installing docker"
apt-get remove docker docker-engine docker.io containerd runc;
apt-get update;
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
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 18.06 | head -1 | awk '{print $3}')

echo "installing kubernetes";
apt-get update;
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update;
apt-get install -y kubelet kubeadm kubectl;
apt-mark hold kubelet kubeadm kubectl;

# DigitalOcean without firewall (IP-in-IP allowed) - or any other cloud / on-prem that supports IP-in-IP traffic
# echo "deploying kubernetes (with calico)..."
# kubeadm init --pod-network-cidr=192.168.0.0/16 # add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP
# export KUBECONFIG=/etc/kubernetes/admin.conf
# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
# kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml


# DigitalOcean with firewall (VxLAN with Flannel) - could be resolved in the future by allowing IP-in-IP in the firewall settings
echo "deploying kubernetes (with canal)...";
if [[ $(curl -SsI http://169.254.169.254/metadata/v1/ | head -1 | grep 200) ]]; then
	CL_ADDR=$(curl -Ss http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address);
	PUBLIC_IP=$(curl -Ss http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address);
	ANCHOR_IP=$(curl -Ss http://169.254.169.254/metadata/v1/interfaces/public/0/anchor_ipv4/address);
else
	CL_ADDR=$(grep  "|--" /proc/net/fib_trie | grep -Pv "0.0.0.0|10.|127\.|\.255$|\.(1|0)$" | awk '{print $2}' | head -1);
fi

#kubeadm init --pod-network-cidr=10.244.0.0/16; # add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address="${CL_ADDR}" --apiserver-cert-extra-sans="${CL_ADDR}" 
export KUBECONFIG=/etc/kubernetes/admin.conf;
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/rbac.yaml;
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/canal.yaml;

