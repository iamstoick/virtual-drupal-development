file "/var/www/index.html" do
  action :delete
end

link "/home/vagrant/www" do
  to "/var/www"
end

# Add www-data to vagrant group
group "vagrant" do
  action :modify
  members "www-data"
  append true
end

group "www-data" do
  action :modify
  members "vagrant"
  append true
end

web_app "localhost" do
  template "localhost.conf.erb"
end

template "/etc/apache2/conf.d/vdd_apache.conf" do
  source "vdd_apache.conf.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end
