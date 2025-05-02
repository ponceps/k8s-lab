#!/bin/bash

CONTROL_PLANE_IP=$1

##############################
# Disable swap
##############################
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

##############################
# Setup prerequisites
##############################
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y containerd.io
containerd config default |
  sed -e "s/SystemdCgroup = false/SystemdCgroup = true/g" |
  sed -e "s/registry.k8s.io\/pause:3.8/registry.k8s.io\/pause:3.10/g" |
  sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

##############################
# Install Kubernetes Packages
##############################
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo mkdir -p /etc/default
sudo apt-get install -y kubeadm=1.32.0-1.1 kubelet=1.32.0-1.1 kubectl=1.32.0-1.1
echo "KUBELET_EXTRA_ARGS=--node-ip=$(hostname -I | awk '{print $2}')" | sudo tee /etc/default/kubelet
sudo apt-mark hold kubeadm kubelet kubectl

echo "$CONTROL_PLANE_IP k8scp" | sudo tee -a /etc/hosts