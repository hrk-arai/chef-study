#
# Cookbook Name:: example_load_balancer
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# sysctlの設定
execute "sysctl -p" do
  action :nothing
end

cookbook_file "/etc/sysctl.conf" do
  source "sysctl.conf"
  notifies :run, 'execute[sysctl -p]', :immediately
end


# nginxのインストールと起動設定
cookbook_file "/etc/yum.repos.d/nginx-mainline.repo" do
  action :create
  source "nginx-mainline.repo"
end

package "nginx" do
  action :install
end

service "nginx" do
  action [:enable, :start]
end

# nginxの設定
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  action :create
  notifies :restart, 'service[nginx]', :immediately
end

template "/etc/nginx/conf.d/default.conf" do
  source "default.conf.erb"
  action :create
  notifies :restart, 'service[nginx]', :immediately
end

directory "/var/cache/nginx/cache" do
  owner 'nginx'
  group 'nginx'
  action :create
end

template "/etc/nginx/conf.d/default.cache.example" do
  source "default.cache.example.erb"
  action :create
  notifies :restart, 'service[nginx]', :immediately
end
