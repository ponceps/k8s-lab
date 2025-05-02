# Kubernetes Lab

A simple and efficient way to set up a local Kubernetes cluster using Vagrant and VirtualBox. This project creates a multi-node Kubernetes cluster with one control plane and two worker nodes, perfect for development, testing, and learning purposes.

> **Note:** This repository is an excellent resource for preparing for the CKAD (Certified Kubernetes Application Developer) and CKA (Certified Kubernetes Administrator) certifications.

## Features

- Single control plane node and two worker nodes
- Ubuntu 24.04 LTS as the base operating system
- Kubernetes 1.32.0
- Cilium CNI for networking
- Helm pre-installed on the control plane
- Automatic cluster initialization and worker node joining
- Port forwarding for Kubernetes API (6443 -> 16443)

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) (latest version)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (latest version)
- At least 4GB of RAM (recommended: 8GB+)
- At least 2 CPU cores (recommended: 4+)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/ponceps/k8s-lab.git
   cd k8s-lab
   ```

2. Start the cluster:
   ```bash
   vagrant up
   ```

3. Access the control plane:
   ```bash
   vagrant ssh controlplane
   ```

4. Verify the cluster status:
   ```bash
   kubectl get nodes
   ```

## Cluster Configuration

- Control Plane:
  - Hostname: controlplane
  - IP: 192.168.56.10
  - Resources: 2 CPU cores, 2GB RAM
  - Kubernetes API: 6443 (host port: 16443)

- Worker Nodes:
  - Hostnames: node01, node02
  - IPs: 192.168.56.11, 192.168.56.12
  - Resources: 1 CPU core, 1GB RAM each

## Network Configuration

- Pod Network CIDR: 10.244.0.0/16
- CNI: Cilium 1.17.2
- Private Network: 192.168.56.0/24

## Included Components

- Docker container runtime
- containerd
- kubeadm, kubelet, and kubectl
- Helm package manager
- Cilium CNI plugin

## Usage

### Accessing the Cluster

1. SSH into the control plane:
   ```bash
   vagrant ssh controlplane
   ```

2. Use kubectl to manage the cluster:
   ```bash
   kubectl get nodes
   kubectl get pods -A
   ```

### Managing the Cluster

- Start the cluster: `vagrant up`
- Stop the cluster: `vagrant halt`
- Destroy the cluster: `vagrant destroy`
- Rebuild the cluster: `vagrant destroy -f && vagrant up`

## Troubleshooting

If you encounter any issues:

1. Check the status of all nodes:
   ```bash
   kubectl get nodes
   ```

2. Check the status of all pods:
   ```bash
   kubectl get pods -A
   ```

3. Check the logs of specific components:
   ```bash
   kubectl logs -n kube-system <pod-name>
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
