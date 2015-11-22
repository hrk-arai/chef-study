#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# see https://docs.chef.io/resources.html#cookbook-file
cookbook_file "create yumrepo of nginx" do
  path "/etc/yum.repos.d/nginx.repo"
  source "nginx.repo"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

# see https://docs.chef.io/resources.html#package
package "nginx" do
  action :install
end

# see https://docs.chef.io/resources.html#service
service "nginx" do
  supports :restart => true
  action [:enable, :start]
end
