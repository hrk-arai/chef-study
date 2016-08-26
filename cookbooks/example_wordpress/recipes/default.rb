#
# Cookbook Name:: example_wordpress
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

# package インストール
cookbook_file "/etc/yum.repos.d/nginx-mainline.repo" do
  action :create
  source "nginx-mainline.repo"
end

package ["nginx", "httpd-tools", "php", "php-mbstring", "php-fpm", "php-mysql"] do
  action :install
end

# サービスの起動と自動起動設定
service "nginx" do
  action [:enable, :start]
end

service "php-fpm" do
  action [:enable, :start]
end

# configファイルの設定
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "nginx"
  group "nginx"
  action :create
  notifies :restart, 'service[nginx]'
end

template "/etc/nginx/conf.d/default.conf" do
  source "default.conf.erb"
  owner "nginx"
  group "nginx"
  action :create
  notifies :restart, 'service[nginx]'
end

template "/etc/php-fpm.d/www.conf" do
  source "www.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, 'service[php-fpm]'
end

# wordpress のインストール
# see https://docs.chef.io/resources.html#remote-file
remote_file "/tmp/latest-ja.tar.gz" do
  source "https://ja.wordpress.org/latest-ja.tar.gz"
end

# see https://docs.chef.io/resources.html#bash
bash 'wordpress deploy package' do
  cwd "/tmp"
  flags "-e"
  code <<-EOH
  tar -zxvf latest-ja.tar.gz
    cp -r wordpress /var/www
    chown -R nginx:nginx /var/www/wordpress
  EOH
  not_if { ::File.exists?("/var/www/wordpress/index.php") }
end

template "/var/www/wordpress/wp-config.php" do
  source "wp-config.php.erb"
  owner "nginx"
  group "nginx"
  action :create
end
