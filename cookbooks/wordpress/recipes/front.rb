#
# nginx settings
#

# see https://docs.chef.io/recipes.html#assign-dependencies
include_recipe 'nginx::default'

# see https://docs.chef.io/resources.html#template
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "nginx"
  group "nginx"
  action :create
  notifies :restart, 'service[nginx]'
end
# see https://docs.chef.io/resources.html#template
template "/etc/nginx/conf.d/default.conf" do
  source "default.conf.erb"
  owner "nginx"
  group "nginx"
  action :create
  notifies :restart, 'service[nginx]'
end

#
# php settings
#

# see https://docs.chef.io/resources.html#multiple-packages
package ["php", "php-mbstring", "php-fpm", "php-mysql"] do
  action :install
end

# see https://docs.chef.io/resources.html#service
service "php-fpm" do
  action [ :enable, :start ]
end

# see https://docs.chef.io/resources.html#template
template "/etc/php-fpm.d/www.conf" do
  source "www.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, 'service[php-fpm]'
end

# ruby code
db_info = search(:node, "cloud_provider:#{node["cloud"]["provider"]} AND role:db")
node.set["wordpress"]["db"]["host"] = db_info[0]["ipaddress"]
lb_info = search(:node, "cloud_provider:#{node["cloud"]["provider"]} AND role:lb")
if !(lb_info.empty?)
  node.set["wordpress"]["lb"]["ipaddress"] = lb_info[0]["ipaddress"]
end
# ruby method
def secure_password(length = 20)
  pw = String.new
  while pw.length < length
    pw << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
  end
  pw
end

#set wordpress key
node.set_unless["wordpress"]["keys"]["auth"] = secure_password
node.set_unless["wordpress"]["keys"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["keys"]["logged_in"] = secure_password
node.set_unless["wordpress"]["keys"]["nonce"] = secure_password
node.set_unless["wordpress"]["salt"]["auth"] = secure_password
node.set_unless["wordpress"]["salt"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["salt"]["logged_in"] = secure_password
node.set_unless["wordpress"]["salt"]["nonce"] = secure_password

#
# wordpress settings
#

# see https://docs.chef.io/resources.html#remote-file
remote_file "/tmp/#{node["wordpress"]["package"]}" do
  source "https://ja.wordpress.org/#{node["wordpress"]["package"]}"
end

# see https://docs.chef.io/resources.html#bash
bash 'wordpress deploy package' do
  cwd "/tmp"
  flags "-e"
  code <<-EOH
  tar -zxvf #{node["wordpress"]["package"]}
    cp -r wordpress #{node["wordpress"]["document_root"]}
    chown -R nginx:nginx #{node["wordpress"]["document_root"]}
  EOH
  not_if { ::File.exists?("#{node["wordpress"]["document_root"]}/index.php") }
end

# see https://docs.chef.io/resources.html#template
template "#{node["wordpress"]["document_root"]}/wp-config.php" do
  source "wp-config.php.erb"
  owner "nginx"
  group "nginx"
  action :create
end
