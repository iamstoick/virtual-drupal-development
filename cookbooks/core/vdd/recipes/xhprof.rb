php_pear "xhprof" do
  preferred_state "beta"
  action :install
end

directory "/tmp/xhprof" do
  mode 00777
  action :create
end

file "/etc/php5/conf.d/xhprof.ini" do
  action :delete
  notifies :restart, "service[apache2]", :delayed
  only_if { File.exists?("/etc/php5/conf.d/xhprof.ini") }
end

template "/etc/php5/conf.d/vdd_xhprof.ini" do
  source "vdd_xhprof.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end

file "/etc/apache2/conf.d/xhprof.conf" do
  action :delete
  notifies :restart, "service[apache2]", :delayed
  only_if { File.exists?("/etc/apache2/conf.d/xhprof.conf") }
end

template "/etc/apache2/conf.d/vdd_xhprof.conf" do
  source "vdd_xhprof.conf.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end

if node["sites"]
  node["sites"].each do |index, site|

    # Make sure that Drupal exist to avoid Chef error
    file_name = "/var/www/#{index}/install.php"
    if File.exists?(file_name)

      execute "devel_xhprof_directory" do
        cwd "/var/www/#{index}/sites/vdd"
        command "drush vset devel_xhprof_directory '/usr/share/php' -y"
        action :run
      end

      execute "devel_xhprof_enabled" do
        cwd "/var/www/#{index}/sites/vdd"
        command "drush vset devel_xhprof_enabled 1 -y"
        action :run
      end

      execute "devel_xhprof_url" do
        cwd "/var/www/#{index}/sites/vdd"
        command "drush vset devel_xhprof_url '/xhprof_html' -y"
        action :run
      end

    end
  end
end

