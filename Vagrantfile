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
  systems = ['grafana', 'snap']
  systems += (1..Integer(number_vms)).collect{|vm| "snap#{vm}"}

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    #config.landrush.guest_redirect_dns = false
  else
    puts "Please run 'vagrant plugin install landrush'"
  end

  systems.each do |vm|
    config.vm.define vm do |system|
      system.vm.box = 'boxcutter/ubuntu1604'

      system.vm.hostname = vm

      system.vm.provision :ansible do |ansible|
        ansible.limit = "all"
        case vm
        when 'grafana'
          ansible.playbook = "docker.yml"
        else
          ansible.playbook = "playbook.yml"
        end
        ansible.sudo = true
        ansible.verbose = true
      end

    end
  end
end
