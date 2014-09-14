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

  # To be ale to use this snippet you must have "vagrant-cachier" installed.
  # Please refer to the doc about installing Vagrant plugin.
  # https://docs.vagrantup.com/v2/plugins/usage.html
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end

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
