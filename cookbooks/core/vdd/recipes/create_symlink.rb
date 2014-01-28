# Create Drupal coding standard symlink inside PHP Codesniffer
link "/usr/share/php/PHP/CodeSniffer/Standards/Drupal" do
  to "/vagrant/bin/coder_module/coder_sniffer/Drupal"
  link_type :symbolic
  action :create
end
