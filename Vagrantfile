# -*- mode: ruby -*-
# vi: set ft=ruby :

# NOTE: override this via the option --provider {provider_name}
ENV["VAGRANT_DEFAULT_PROVIDER"] = "virtualbox"

Vagrant.configure(2) do |config|
  # Global settings:
  config.vm.provider "virtualbox" do |vm|
    vm.linked_clone = true
  end

  number_vms = ENV["SNAP_DEMO_VMS"] || 1
  systems = ['grafana']
  systems += (1..Integer(number_vms)).collect{|vm| "snap#{vm}"}

  if Vagrant.has_plugin?("landrush")
    config.landrush.enabled = true
    config.landrush.guest_redirect_dns = false
  else
    puts "Please run 'vagrant plugin install landrush'"
  end

  systems.each do |vm|
    config.vm.define vm do |system|
      system.vm.box = 'boxcutter/ubuntu1604'

      system.vm.hostname = vm

      if vm == 'grafana'
        system.vm.network "forwarded_port", guest: 80, host: 8080
        system.vm.network "forwarded_port", guest: 3000, host: 3000
      end

      system.vm.provision :ansible do |ansible|
        ansible.limit = "all"
        ansible.playbook = "playbook.yml"
        ansible.sudo = true
        ansible.verbose = true if ENV['ANSIBLE_VERBOSE']
      end if vm == "snap#{number_vms}"

    end
  end
end
