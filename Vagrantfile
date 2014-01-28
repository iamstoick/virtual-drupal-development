Vagrant.configure("2") do |config|

  # Load config JSON
  vdd_config_path = File.expand_path(File.dirname(__FILE__)) + "/config.json"
  vdd_config = JSON.parse(File.read(vdd_config_path))

  # Forward Agent
  #
  # Enable agent forwarding on vagrant ssh commands. This allows you to use identities
  # established on the host machine inside the guest. See the manual for ssh-add
  config.ssh.forward_agent = true

  # Base box
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Machine hostname
  config.vm.hostname = vdd_config["hostname"]

  # Networking
  config.vm.network :private_network, ip: vdd_config["ip"]

  # Customize provider
  config.vm.provider :virtualbox do |vb|
    # RAM
    vb.customize ["modifyvm", :id, "--memory", vdd_config["memory"]]

    # Synced Folder
    if vdd_config["synced_folder"]["use_nfs"]
      config.vm.synced_folder vdd_config["synced_folder"]["host_path"],
      vdd_config["synced_folder"]["guest_path"],
      :nfs => true
    else
      config.vm.synced_folder vdd_config["synced_folder"]["host_path"],
      vdd_config["synced_folder"]["guest_path"],
      :owner => "www-data",
      :group => "vagrant"
    end

=begin
 This is for vassh and vasshin to work properly (let this line commented and indented the way it is)
 https://github.com/x-team/vassh/
 config.vm.synced_folder "www/", "/var/www/"
=end

    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Customize provisioner
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [
      "cookbooks/site",
      "cookbooks/core",
      "cookbooks/custom"
    ]
    chef.roles_path = "roles"

    # Prepare chef JSON
    chef.json = vdd_config

    # Add VDD role
    chef.add_role "vdd"

    # Add custom roles
    vdd_config["custom_roles"].each do |role|
      chef.add_role role
    end
  end

end
