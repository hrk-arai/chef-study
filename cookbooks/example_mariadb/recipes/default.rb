#
# Cookbook Name:: example_mariadb
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# packageインストール
package ["mariadb", "mariadb-server"] do
  action :install
end

# サービス設定
service "mariadb" do
  action [:enable, :start]
end

# conf設定
template "/etc/my.cnf" do
  source "my.cnf.erb"
  action :create
  notifies :restart, 'service[mariadb]'
end

# sqlファイルを実行
execute "create-db" do
  command "mysql < /tmp/create-wordpress.sql"
  action :nothing
end

# DB作成用のsqlファイル生成
template "/tmp/create-wordpress.sql" do
  source "create-wordpress.sql.erb"
  action :create
  notifies :run, "execute[create-db]", :immediately
end
