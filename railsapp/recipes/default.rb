# spawn of http://github.com/opscode/rails_infra_repo/blob/master/site-cookbooks/application/recipes/default.rb

r = gem_package "chef-deploy" do
  source "http://gemcutter.org"
  action :nothing
end
r.run_action(:install) #do it now, not later

Gem.clear_paths
require "chef-deploy"

include_recipe "passenger_apache2::mod_rails"
include_recipe "rails"
include_recipe "git"
include_recipe "mysql::client"

include_recipe "railsapp::web_user"

include_recipe "railsapp::directories"

# templated database.yml
template "/srv/#{node[:railsapp][:app_name]}/shared/config/database.yml" do
  source "database.yml.erb"
  owner node[:railsapp][:user][:name]
  group "sysadmin"
  mode "0664"
end

# templated varnish.yml
cachers = search(:node, "hostname:cache*+AND+domain:#{node[:domain]}")
template "/srv/#{node[:railsapp][:app_name]}/shared/config/varnish.yml" do
  source "varnish.yml.erb"
  owner node[:railsapp][:user][:name]
  group "sysadmin"
  mode "0664"
  variables :cachers => cachers
end

# Decision to stick with capistrano
#
# deploy "/srv/#{node[:railsapp][:app_name]}" do
#   scm_provider Chef::Provider::Git
#   repo node[:railsapp][:repository]
#   branch node[:railsapp][:branch]
#   user node[:railsapp][:user][:name]
#   enable_submodules true
#   migrate node[:railsapp][:migrate]
#   migration_command "rake production db:migrate"
#   environment node[:railsapp][:environment]
#   symlink_before_migrate({"config/database.yml" => "config/database.yml", "config/varnish.yml" => "config/varnish.yml"})
#   shallow_clone true
#   revision node[:railsapp][:revision]
#   restart_command "touch tmp/restart.txt"
#   action node[:railsapp][:action].to_sym
# end

web_app "#{node[:railsapp][:app_name]}" do
  docroot "/srv/#{node[:railsapp][:app_name]}/current/public"
  template "railsapp.conf.erb"
  server_name node[:fqdn]
end

apache_site "000-default" do
  enable false
end