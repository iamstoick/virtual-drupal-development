if node["sites"]

  node["sites"].each do |index, site|

    # Make sure that Drupal exist to avoid Chef error
    file_name = "/var/www/#{index}/install.php"
    if File.exists?(file_name)
      include_recipe "database::mysql"

      mysql_connection_info = {
        :host => "localhost",
        :username => "root",
        :password => node["mysql"]["server_root_password"]
      }

      mysql_database index do
        connection mysql_connection_info
        action :create
      end

      # Make sure that database file exists
      database_file = "/var/www/#{index}/database/vagrant.sql"
      if File.exists?(database_file)
        # Import an sql dump from your #{index}/database/vagrant.sql to the database
        execute "import" do
          command "mysql -u root -p\"#{node['mysql']['server_root_password']}\" #{index} < /var/www/#{index}/database/vagrant.sql"
          action :run
          # Do not run if the database already exists
          not_if "[ $(mysql -uroot -p\"#{node['mysql']['server_root_password']}\" -e\"SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema = '#{index}'\" | tail -1) != 0 ]"
        end
      end
    end
  end
end
