#
# Cookbook Name:: icingaweb2
# Recipe:: apache
#
# Copyright 2017, Virender Khatri
#

node.default['apache']['servertokens'] = 'Minimal'
node.default['apache']['mpm'] = 'prefork'

if node['platform'] == 'amazon'
  node.default['apache']['mod_ssl']['pkg_name'] = 'mod_ssl'
  node.default['apache']['package'] = 'httpd'
  node.default['apache']['devel_package'] = 'httpd-devel'
end

node['icingaweb2']['apache_modules'].each { |mod| include_recipe "apache2::#{mod}" }

if node['lsb']['codename'] == 'trusty'
  package 'libapache2-mod-php5' do
    action :install
    notifies :reload, 'service[apache2]', :delayed
  end
end

if (node['platform_family'] == 'debian') && (node['lsb']['codename'] == 'xenial') # ~FC023
  apache_module 'php7.0' do
    conf false
    filename 'libphp7.0.so'
    identifier 'php7_module'
    notifies platform?('windows') ? :restart : :reload, 'service[apache2]'
  end
end

template ::File.join(node['apache']['dir'], 'conf-available', 'icinga2-web2.conf') do
  source node['icingaweb2']['apache_web2_template']
  owner node['apache']['user']
  group node['apache']['group']
  cookbook node['icingaweb2']['apache_conf_cookbook']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:web_root => node['icingaweb2']['web_root'],
            :web_uri => node['icingaweb2']['web_uri'],
            :conf_dir => node['icingaweb2']['conf_dir'])
end

apache_config 'icinga2-web2'

# group resource for user nagios
group node['icingaweb2']['group'] do
  only_if { node['platform_family'] == 'debian' }
  append true
end

user 'nagios' do
  gid 'nagios'
  system true
  only_if { node['platform_family'] == 'debian' }
end

# add group members
group "manage_members_#{node['icingaweb2']['group']}" do
  group_name node['icingaweb2']['group']
  members [node['apache']['user'], node['icingaweb2']['user']]
  only_if { node['platform_family'] == 'debian' }
  notifies :restart, 'service[apache2]', :delayed
  action :modify
end
