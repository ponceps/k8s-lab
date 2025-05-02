# -*- mode: ruby -*-
# vi: set ft=ruby :

NodeBox = "bento/ubuntu-24.04"
BASE_IP = "192.168.56"
CONTROL_PLANE_IP = "#{BASE_IP}.10"
WORKER_NODES = 2

Vagrant.configure("2") do |config|
  config.vm.define "controlplane" do |node|
    node.vm.box = NodeBox
    node.vm.hostname = "controlplane"
    node.vm.network "private_network", ip: CONTROL_PLANE_IP
    node.vm.network "forwarded_port", guest: 6443, host: 16443
    node.vm.provider "virtualbox" do |vb|
      vb.name = "controlplane"
      vb.memory = "2048"
      vb.cpus = "2"
    end
    node.vm.provision "shell", path: "common.sh", args: [CONTROL_PLANE_IP]
    node.vm.provision "shell", path: "master.sh"
  end

  (1..WORKER_NODES).each do |i|
    config.vm.define "node0#{i}" do |node|
      node.vm.box = NodeBox
      node.vm.hostname = "node0#{i}"
      node.vm.network "private_network", ip: "#{BASE_IP}.#{10 + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "node0#{i}"
        vb.memory = "1024"
        vb.cpus = "1"
      end
      node.vm.provision "shell", path: "common.sh", args: [CONTROL_PLANE_IP]
      node.vm.provision "shell", path: "worker.sh"
    end
  end
end
