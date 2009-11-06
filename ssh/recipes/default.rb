#http://github.com/37signals/37s_cookbooks/blob/master/cookbooks/ssh/recipes/server.rb

service "ssh" do
  supports :restart => true, :reload => true
  action :enable
end
 
template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "ssh")
end
 
service "ssh" do
  action :start
end