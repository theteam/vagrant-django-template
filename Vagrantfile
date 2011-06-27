
Vagrant::Config.run do |config|
  config.ssh.max_tries = 50
  config.ssh.timeout = 300

  # Machine Definitions
  config.vm.define :base do |django_stack|
  
    django_stack.vm.host_name = "vagrant-node"
    django_stack.vm.box = "base"
    django_stack.vm.box_url = "http://files.vagrantup.com/lucid64.box"
    
    # Uncomment the boot_mode line to move
    # away from headless non-gui mode.
    #django_stack.vm.boot_mode = :gui

    # Enable the Puppet provisioner
    django_stack.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "theteam-website.pp"
      #puppet.options = "--verbose --debug"
    end

    # Port forwarding to local machine.
    django_stack.vm.forward_port("web", 80, 8000)
  end
end
