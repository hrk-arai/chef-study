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

describe ("Test nginx") do
  describe package("nginx") do
    it { should be_installed }
  end

  describe service("nginx") do
    it { should be_enabled }
    it { should be_running }
  end
end

describe ("Test nginx setting") do
  describe file("/etc/nginx/nginx.conf") do
    it { should exist }
  end
  describe file("/etc/nginx/conf.d/default.conf") do
    it { should exist }
    its(:content) { should match /^\s*server\s*[0-9,.]*\s*;/ }
  end
  describe file("/var/cache/nginx/cache") do
    it { should be_directory }
    it { should be_owned_by 'nginx' }
    it { should be_grouped_into 'nginx' }
  end
  describe file("/etc/nginx/conf.d/default.cache.example") do
    it { should exist }
    its(:content) { should match /^\s*server\s*[0-9,.]*\s*;/ }
  end
end
