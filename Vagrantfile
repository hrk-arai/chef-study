# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "load_balancer" do |server|
    server.vm.box_check_update = false
    server.vm.box = "opscode-centos-7.2"
    server.vm.hostname = "load-balancer"
    server.vm.network "private_network", ip: "192.168.33.10"
    config.vm.provision "chef_solo" do |chef|
    # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "example_load_balancer"
      chef.json = {
        "example_load_balancer" => {
          "wp01_ipaddress" => "192.168.33.11",
          "wp02_ipaddress" => "192.168.33.12"
        }
      }
    end
  end

  config.vm.define "wp01" do |server|
    server.vm.box_check_update = false
    server.vm.box = "opscode-centos-7.2"
    server.vm.hostname = "wp01"
    server.vm.network "private_network", ip: "192.168.33.11"
    config.vm.provision "chef_solo" do |chef|
    # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "example_wordpress"
      chef.json = {
        "example_wordpress" => {
          "db01_ipaddress" => "192.168.33.13"
        }
      }
    end
  end

  config.vm.define "wp02" do |server|
    server.vm.box_check_update = false
    server.vm.box = "opscode-centos-7.2"
    server.vm.hostname = "wp02"
    server.vm.network "private_network", ip: "192.168.33.12"
    config.vm.provision "chef_solo" do |chef|
    # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "example_wordpress"
      chef.json = {
        "example_wordpress" => {
          "db01_ipaddress" => "192.168.33.13"
        }
      }
    end
  end

  config.vm.define "db01" do |server|
    server.vm.box_check_update = false
    server.vm.box = "opscode-centos-7.2"
    server.vm.hostname = "db02"
    server.vm.network "private_network", ip: "192.168.33.13"
    config.vm.provision "chef_solo" do |chef|
    # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "example_mariadb"
      chef.json = {
        "example_mariadb" => {
          "wp01_ipaddress" => "192.168.33.11",
          "wp02_ipaddress" => "192.168.33.12"
        }
      }
    end
  end
end
