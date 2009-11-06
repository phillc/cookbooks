directory "/srv/#{node[:railsapp][:app_name]}" do
  recursive true
  owner node[:railsapp][:user][:name]
  group "sysadmin"
  mode "0775"
end

%w{shared releases}.each do |dir|
  directory "/srv/#{node[:railsapp][:app_name]}/#{dir}" do
    recursive true
    owner node[:railsapp][:user][:name]
    group "sysadmin"
    mode "0775"
  end
end

%w{config log pids system}.each do |dir|
  directory "/srv/#{node[:railsapp][:app_name]}/shared/#{dir}" do
    recursive true
    owner node[:railsapp][:user][:name]
    group "sysadmin"
    mode "0775"
  end
end