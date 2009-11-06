# Need a user to run everything as
user node[:railsapp][:user][:name] do
  comment "User for web services"
  home "/home/#{node[:railsapp][:user][:name]}"
  supports :manage_home => true
  action [:create, :manage]
end

#then give him public/private key that allows him into the git repository
directory "/home/#{node[:railsapp][:user][:name]}/.ssh" do
  action :create
  owner node[:railsapp][:user][:name]
  group node[:railsapp][:user][:name]
  mode 0700
end

if node[:railsapp][:user][:pubkey]
  template "/home/#{node[:railsapp][:user][:name]}/.ssh/id_rsa.pub" do
    source "pubkey.erb"
    action :create
    owner node[:railsapp][:user][:name]
    group node[:railsapp][:user][:name]
    mode 0600
  end
end

if node[:railsapp][:user][:privatekey]
  template "/home/#{node[:railsapp][:user][:name]}/.ssh/id_rsa" do
    source "privatekey.erb"
    action :create
    owner node[:railsapp][:user][:name]
    group node[:railsapp][:user][:name]
    mode 0600
  end
end