if node["sites"]

  node["sites"].each do |index, site|
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

    # Import an sql dump from your #{index}/database/vagrant.sql to the database
    execute "import" do
      command "mysql -u root -p\"#{node['mysql']['server_root_password']}\" #{index} < /var/www/#{index}/database/vagrant.sql"
      action :run
      # Do not run if the database already exists
      not_if "mysql -uroot -p\"#{node['mysql']['server_root_password']}\" -e'show databases' | grep #{index}"
    end

  end
end
