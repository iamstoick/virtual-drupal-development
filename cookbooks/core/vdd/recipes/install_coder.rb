if node["sites"]
  node["sites"].each do |index, site|

    # Create Drupal coding standard symlink inside PHP Codesniffer
    link "/usr/share/php/PHP/CodeSniffer/Standards/Drupal" do
      to "/vagrant/bin/coder_module/coder_sniffer/Drupal"
      link_type :symbolic
      action :create
    end

     # Make sure that Drupal exist to avoid Chef error
    file_name = "/var/www/#{index}/install.php"
    if File.exists?(file_name)
      # Create symlink of coder_module inside Drupal contrib directory
      link "/var/www/#{index}/sites/all/modules/contrib/coder_module" do
        to "/vagrant/bin/coder_module"
        link_type :symbolic
        action :create
      end

      # Enable the coder module using Drush
      execute "install_coder" do
        cwd "/var/www/#{index}/sites/vdd"
        command "drush en coder --yes"
        action :run
      end

      # Enable the coder module using Drush
      execute "install_coder_review" do
        cwd "/var/www/#{index}/sites/vdd"
        command "drush en coder_review --yes"
        action :run
      end
    end

  end
end
