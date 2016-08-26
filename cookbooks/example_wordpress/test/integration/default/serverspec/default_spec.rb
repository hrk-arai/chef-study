require 'spec_helper'

describe ("Test sysctl") do
  describe file("/etc/sysctl.conf") do
    it { should exist }
    its(:content) { should match /net.ipv4.tcp_tw_recycle = 1/ }
    its(:content) { should match /net.ipv4.tcp_tw_reuse = 1/ }
    its(:content) { should match /net.ipv4.tcp_max_syn_backlog = 100000/ }
#    its(:content) { should match /net.netfilter.nf_conntrack_max = 100000/ }
#    its(:content) { should match /net.nf_conntrack_max = 100000/ }
    its(:content) { should match /fs.file-max = 320000/ }
  end
end

describe ("Test packges") do
  describe package("nginx") do
    it { should be_installed }
  end
  describe package("httpd-tools") do
    it { should be_installed }
  end
  describe package("php") do
    it { should be_installed }
  end
  describe package("php-mbstring") do
    it { should be_installed }
  end
  describe package("php-fpm") do
    it { should be_installed }
  end
  describe package("php-mysql") do
    it { should be_installed }
  end
end

describe ("Test nginx") do
  describe service("nginx") do
    it { should be_enabled }
    it { should be_running }
  end
  describe file("/etc/nginx/conf.d/default.conf") do
    it { should exist }
  end
end

describe ("Test php-fpm") do
  describe service("php-fpm") do
    it { should be_enabled }
    it { should be_running }
  end
  describe file("/etc/php-fpm.d/www.conf") do
    it { should exist }
  end
end

describe ("Test wordpress") do
  describe file("/var/www/wordpress/index.php") do
    it { should exist }
  end
  describe file("/var/www/wordpress/wp-config.php") do
    it { should exist }
  end
end
