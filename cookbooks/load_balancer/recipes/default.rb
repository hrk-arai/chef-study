#
# Cookbook Name:: load_balancer
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# see https://docs.chef.io/recipes.html#assign-dependencies
include_recipe 'nginx::default'

# see https://docs.chef.io/resources.html#file
file "/etc/nginx/conf.d/default.conf" do
  action :delete
end

# get ipaddress of role[web]
web_info = search(:node, "cloud_provider:#{node["cloud"]["provider"]} AND role:web")
node.set["load_balancer"]["web_ip"] = []
web_info.each do |web|
  node.set["load_balancer"]["web_ip"].push(web["ipaddress"])
end

# see https://docs.chef.io/resources.html#template
# see https://docs.chef.io/resources.html#notifications
template "/etc/nginx/conf.d/default.conf" do
  source "nginx-lb-default.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart , "service[nginx]", :immediately
end





=begin
web_info = search(:node, "cloud_provider:#{node["cloud"]["provider"]} AND role:web")
node.set["load_balancer"]["web_ip"] = []
web_info.each do |web|
  node.set["load_balancer"]["web_ip"].push(web["ipaddress"])
end

package "httpd"

template "/etc/httpd/conf.d/load_balancer.conf" do
  source "load_balancer.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[httpd]', :immediately
end

service "httpd" do
  action [ :start, :enable ]
  supports :restart => true
end
=end
