template "/var/www/index.html" do
  source "vdd_help.html.erb"
  variables(
    :sites => node["sites"]
  )
end
