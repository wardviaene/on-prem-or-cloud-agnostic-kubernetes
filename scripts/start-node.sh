#!/bin/bash
echo "cloning github repo"
git clone https://github.com/carlosvalarezo/on-prem-or-cloud-agnostic-kubernetes.git

echo "installing k8s tools"
cd on-prem-or-cloud-agnostic-kubernetes
scripts/install-node.sh
