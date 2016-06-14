# -*- mode: ruby -*-
# vi: set ft=ruby :

# NOTE: override this via the option --provider {provider_name}
ENV["VAGRANT_DEFAULT_PROVIDER"] = "virtualbox"

Vagrant.configure(2) do |config|
  # Global settings:
  config.vm.provider "virtualbox" do |vm|
    vm.linked_clone = true
  end

  number_vms = ENV["SNAP_DEMO_VMS"] || 4
  systems = ['docker']
  systems += (1..Integer(number_vms)).collect{|vm| "snap#{vm}"}

  systems.each do |vm|
    config.vm.define vm do |system|
      system.vm.box = 'boxcutter/ubuntu1604'

      system.vm.hostname = vm

      #system.vm.network :private_network, ip: :q

      system.vm.provision :hosts do |host|
        host.autoconfigure = true
        host.sync_hosts = true
        host.exports = {
          'virtualbox' => [
            ['@vagrant_private_networks', ['@vagrant_hostnames']],
          ],
        }
      end

      system.vm.provision :ansible do |ansible|
        case vm
        when 'docker'
          ansible.playbook = "docker.yml"
        else
          ansible.playbook = "snap.yml"
        end
        ansible.sudo = true
      end

    end
  end
end
