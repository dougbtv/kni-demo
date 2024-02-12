#!/usr/bin/env bash
set -e
set -o pipefail

kind delete cluster --name test1 || true

kind create cluster --config kind.yaml --name test1
kubectl cluster-info --context kind-test1

# kind load docker-image gchr.io/mikezappa87/flannel:KNI-POC --name test1
docker pull docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
docker pull docker.io/flannel/flannel:v0.24.2
docker pull docker.io/dougbtv/multus-cni:kni-poc
kind load docker-image docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1 --name test1
kind load docker-image docker.io/flannel/flannel:v0.24.2 --name test1
kind load docker-image docker.io/dougbtv/multus-cni:kni-poc --name test1

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

kubectl taint node test1-control-plane node-role.kubernetes.io/control-plane:NoSchedule-
