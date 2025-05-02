#!/bin/bash

##############################
# Install Kubernetes
##############################

# Initialize Kubernetes
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$CONTROL_PLANE_IP --control-plane-endpoint="k8scp:6443" --upload-certs
sudo kubeadm token create --print-join-command > /vagrant/joincluster.sh

# Configure kubectl
mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

# Enable kubectl completion
sudo apt-get update
sudo apt-get install -y bash-completion
echo 'source <(kubectl completion bash)' >> ~vagrant/.bashrc
echo 'alias k=kubectl' >> ~vagrant/.bashrc
echo 'complete -F __start_kubectl k' >> ~vagrant/.bashrc

# Install Helm
sudo snap install helm --classic
sleep 5 # Wait for helm to install

# Install Cilium
export PATH=/snap/bin:$PATH
export KUBECONFIG=/home/vagrant/.kube/config
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --namespace kube-system --version 1.17.2
