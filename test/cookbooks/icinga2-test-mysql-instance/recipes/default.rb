mysql_version = node['lsb']['codename'] == 'xenial' ? '5.7' : '5.5'
mysql_service_manager = node['icinga2-test-mysql-instance']['service_manager']
mysql2_gem_action = node['lsb']['codename'] == 'xenial' ? %i[remove install] : :install

if %w[centos amazon].include?(node['platform'])
  yum_repository 'mysql55-community' do
    # amzon platform version fix
    if node['platform'] == 'amazon'
      baseurl 'http://repo.mysql.com/yum/mysql-5.7-community/el/6/$basearch/'
    else
      baseurl node['yum']['mysql55-community']['baseurl'] unless node['yum']['mysql55-community']['baseurl'].nil?
    end
    mirrorlist node['yum']['mysql55-community']['mirrorlist'] unless node['yum']['mysql55-community']['mirrorlist'].nil?
    description node['yum']['mysql55-community']['description'] unless node['yum']['mysql55-community']['description'].nil?
    failovermethod node['yum']['mysql55-community']['failovermethod'] unless node['yum']['mysql55-community']['failovermethod'].nil?
    enabled true
    gpgcheck true
    gpgkey node['yum']['mysql55-community']['gpgkey'] unless node['yum']['mysql55-community']['gpgkey'].nil?
    action :create
  end
end

mysql2_chef_gem 'default' do
  package_version mysql_version
  action mysql2_gem_action
end

mysql_service 'test-mysql' do
  port '3306'
  service_manager mysql_service_manager unless mysql_service_manager.nil?
  version mysql_version
  initial_root_password 'Xvtd7I9Hp2'
  action %i[create start]
end

mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => 'Xvtd7I9Hp2'
}

mysql_database 'icinga' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'icinga' do
  connection mysql_connection_info
  password 'X2BM0WKnN'
  database_name 'icinga'
  privileges [:all]
  action %i[create grant]
end
