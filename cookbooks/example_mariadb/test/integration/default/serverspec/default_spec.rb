require 'spec_helper'

describe ("Test mariadb") do
  describe package("mariadb") do
    it { should be_installed }
  end
  describe package("mariadb-server") do
    it { should be_installed }
  end

  describe service("mariadb") do
    it { should be_enabled }
    it { should be_running }
  end
end

describe ("Test mariadb setting") do
  describe file("/etc/my.cnf") do
    it { should exist }
  end
  describe command("mysql -e \"SHOW DATABASES;\"") do
    its(:stdout) { should match /wordpress/}
  end
  describe command("mysql -e \"SELECT * FROM mysql.user\" | grep wordpress | wc -l") do
    its(:stdout) { should match /2/}
  end
end
