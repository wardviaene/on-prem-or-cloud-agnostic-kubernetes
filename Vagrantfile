# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_MEM = ENV['BOX_MEM'] || "1024"
BOX_NAME =  ENV['BOX_NAME'] || "ubuntu/bionic64"
PROVIDER = ENV['PROVIDER'] || "virtualbox"
VAGRANTFILE_API_VERSION = "2"
WORKER_COUNT = ENV['WORKER_COUNT'] || 3

Vagrant.require_version ">= 1.8.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :"k8s-master" do |k8s_master|
    k8s_master.vm.box = BOX_NAME
    k8s_master.vm.synced_folder ".", "/vagrant", disabled: false
    k8s_master.ssh.shell = "/bin/bash"
    k8s_master.ssh.forward_agent = true
    k8s_master.vm.network :private_network, ip: "172.16.32.80"
    k8s_master.vm.hostname = "k8s-master.local"
    k8s_master.vm.provider PROVIDER do |v|
      v.name = "k8s-master"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    k8s_master.vm.post_up_message = "K8s-master ready!"
    end
    k8s_master.vm.provision :hosts do |provisioner|
      provisioner.add_host '172.16.32.80', ['k8s-master.local', 'k8s-master']
      provisioner.add_host '172.16.32.81', ['k8s-worker-01.local', 'k8s-worker-01']
      provisioner.add_host '172.16.32.82', ['k8s-worker-02.local', 'k8s-worker-02']    
    end
  end
  config.vm.define :"k8s-worker-01" do |k8s_worker_01|
    k8s_worker_01.vm.box = BOX_NAME
    k8s_worker_01.vm.synced_folder ".", "/vagrant", disabled: false
    k8s_worker_01.ssh.shell = "/bin/bash"
    k8s_worker_01.ssh.forward_agent = true
    k8s_worker_01.vm.network :private_network, ip: "172.16.32.81"
    k8s_worker_01.vm.hostname = "k8s-worker-01.local"
    k8s_worker_01.vm.provider PROVIDER do |v|
      v.name = "k8s-worker-01"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    k8s_worker_01.vm.post_up_message = "K8s-worker-01 ready!"
    end
    k8s_worker_01.vm.provision :hosts do |provisioner|
      provisioner.add_host '172.16.32.80', ['k8s-master.local', 'k8s-master']
      provisioner.add_host '172.16.32.81', ['k8s-worker-01.local', 'k8s-worker-01']
      provisioner.add_host '172.16.32.82', ['k8s-worker-02.local', 'k8s-worker-02']    
    end
  end
  config.vm.define :"k8s-worker-02" do |k8s_worker_02|    
    k8s_worker_02.vm.box = BOX_NAME    
    k8s_worker_02.vm.synced_folder ".", "/vagrant", disabled: false    
    k8s_worker_02.ssh.shell = "/bin/bash"    
    k8s_worker_02.ssh.forward_agent = true    
    k8s_worker_02.vm.network :private_network, ip: "172.16.32.81"
    k8s_worker_02.vm.hostname = "k8s-worker-02.local"
    k8s_worker_02.vm.provider PROVIDER do |v|
      v.name = "k8s-worker-02"
      v.customize ["modifyvm", :id, "--memory", BOX_MEM]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    k8s_worker_02.vm.post_up_message = "K8s-worker-02 ready!"
    end                                                                                                                                                                                  
    k8s_worker_02.vm.provision :hosts do |provisioner|    
      provisioner.add_host '172.16.32.80', ['k8s-master.local', 'k8s-master']    
      provisioner.add_host '172.16.32.81', ['k8s-worker-01.local', 'k8s-worker-01']    
      provisioner.add_host '172.16.32.82', ['k8s-worker-02.local', 'k8s-worker-02']    
    end
  end
  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
