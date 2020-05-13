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

echo "installing helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

echo "setup helm"
kubectl create -f $PWD/rbac-config.yml
helm init --service-account tiller

echo "setup ingress-controller"
helm install --name my-ingress stable/nginx-ingress \
    --set controller.kind=DaemonSet \
    --set controller.service.type=NodePort \
    --set controller.hostNetwork=true

kubectl apply -f $PWD/cert-manager/myapp.yml
kubectl apply -f $PWD/cert-manager/myapp-ingress.yml

echo 'setup cert-manager'
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install --name cert-manager --namespace cert-manager jetstack/cert-manager

kubectl apply -f $PWD/cert-manager/issuer-staging.yml
