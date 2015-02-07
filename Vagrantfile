# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  (1..3).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.network "private_network", ip: "20.20.20.2#{i}"
    end
  end

  # install docker and weave
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update

    # install docker and weave
    sudo apt-get install -y docker.io
    sudo usermod -a -G docker vagrant
    sudo wget -q -O /usr/local/bin/weave https://github.com/zettio/weave/releases/download/latest_release/weave
    sudo chmod a+x /usr/local/bin/weave
  SHELL

  end

  # setting up hostname
  (1..3).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.provision "shell", inline: <<-SHELL
        echo "node#{i}" >> /etc/hostname
        hostname -F /etc/hostname
      SHELL
    end
  end
