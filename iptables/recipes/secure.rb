include_recipe "iptables"

ips = {}

(node[:iptables][:domain] || {}).each do |region, ports|
  search(:node, "hostname:#{region}*+AND+domain:#{node[:domain]}").collect{|n| n["internal_ip"]}.each do |ip|
    ips[ip] = [] unless ips[ip]
    ips[ip].concat(ports)
  end
end

internal_ports = node[:iptables][:internal]
if internal_ports
  search(:node, "internal_ip:?*").collect{|n| n["internal_ip"]}.each do |ip|
    ips[ip] = [] unless ips[ip]
    ips[ip].concat(internal_ports)
  end
end

(node[:iptables].reject{|k,v| k == "domain" || k == "internal"} || []).each do |ip, ports|
  ips[ip] = [] unless ips[ip]
  ips[ip].concat(ports)
end

iptables_rule "b_ssh"  
iptables_rule "c_world" do
  variables :ports => node[:iptables][:all] || []
end
iptables_rule "d_specific" do
  variables :ips => ips
end
iptables_rule "x_log"