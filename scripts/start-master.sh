#!/bin/bash

echo "cloning github repo"
git clone https://github.com/carlosvalarezo/on-prem-or-cloud-agnostic-kubernetes.git

echo "installing k8s tools"
cd on-prem-or-cloud-agnostic-kubernetes
sudo scripts/install-kubernetes.sh

echo "changing user"
sudo cp -r /root/.ssh /home/ubuntu/.ssh
sudo chown -R ubuntu:ubuntu /home/ubuntu
sudo echo "ubuntu ALL=(ALL:ALL) NOPASSWD:ALL" >>/etc/sudoers
mkdir -p ~ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf ~ubuntu/.kube/config
sudo chown ubuntu:ubuntu ~ubuntu/.kube/config

echo "getting ready for cert-manager"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
