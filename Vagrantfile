Vagrant::Config.run do |config|
  config.ssh.max_tries = 50
  config.ssh.timeout = 300
  config.vm.define :base do |node|
    node.vm.host_name = "node"
    node.vm.box = "base"
    node.vm.box_url = "http://files.vagrantup.com/lucid64.box"
    node.vm.boot_mode = :gui
    # Enable the Puppet provisioner
    node.vm.provision :puppet do |puppet|
      puppet.manifests_path = "./manifests"
      puppet.module_path = "./modules"
      puppet.manifest_file = "base.pp"
    end
    node.vm.forward_port("web", 80, 8000)
  end
end
