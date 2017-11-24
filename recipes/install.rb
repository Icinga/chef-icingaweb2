# frozen_string_literal: true
#
# Cookbook Name:: icingaweb2
# Recipe:: install
#
# Copyright 2014, Virender Khatri
#

cli_package_version = node['icingaweb2']['version']['icingacli'] + node['icingaweb2']['version_suffix']
web2_package_version = node['icingaweb2']['version']['icingaweb2'] + node['icingaweb2']['version_suffix']
web2_source_version = 'v' + node['icingaweb2']['version']['icingaweb2'].split('-')[0]

if node.attribute?('time') && node['time'].attribute?('timezone')
  timezone = node['time']['timezone']
else
  timezone = 'UTC'
  Chef::Log.warn("missing attribute node['time']['timezone'], using default value 'UTC'")
end

# set php time zone
php_ini = if %w[rhel amazon fedora].include?(node['platform_family'])
            '/etc/php.ini'
          elsif node['platform_family'] == 'debian'
            if node['lsb']['codename'] == 'xenial'
              '/etc/php/7.0/apache2/php.ini'
            else
              '/etc/php5/apache2/php.ini'
            end
          else
            raise "platform_family #{node['platform_family']} not supported"
          end

ruby_block 'set php timezone' do
  block do
    fe = Chef::Util::FileEdit.new(php_ini)
    fe.search_file_replace_line(/^;date.timezone =.*/, "date.timezone = #{timezone}")
    fe.write_file
  end
end

# install icingaweb2
if node['icingaweb2']['install_method'] == 'source'
  package 'icingaweb2' do
    action :remove
  end

  directory node['icingaweb2']['web_root'] do
    owner node[node['icingaweb2']['web_engine']]['user']
    group node[node['icingaweb2']['web_engine']]['group']
    mode '0775'
  end

  git node['icingaweb2']['web_root'] do
    repository node['icingaweb2']['source_url']
    revision web2_source_version
    user node[node['icingaweb2']['web_engine']]['user']
    group node[node['icingaweb2']['web_engine']]['group']
    only_if { node['icingaweb2']['install_method'] == 'source' }
  end

else
  package 'icingaweb2' do
    # skip ubuntu version for now
    version web2_package_version unless node['icingaweb2']['ignore_version']
    notifies :restart, 'service[apache2]', :delayed
  end

  package 'icingacli' do
    version cli_package_version unless node['icingaweb2']['ignore_version']
    notifies :restart, 'service[apache2]', :delayed
  end

  if node['platform'] == 'debian'
    package 'icingaweb2-module-monitoring' do
      version web2_package_version unless node['icingaweb2']['ignore_version']
      notifies :restart, 'service[apache2]', :delayed
    end

    package 'icingaweb2-module-doc' do
      version web2_package_version unless node['icingaweb2']['ignore_version']
      notifies :restart, 'service[apache2]', :delayed
    end
  end
end

icinga2_feature 'command'

directory node['icingaweb2']['conf_dir'] do
  owner node[node['icingaweb2']['web_engine']]['user']
  group node[node['icingaweb2']['web_engine']]['group']
  mode '02770'
end

directory ::File.join(node['icingaweb2']['conf_dir'], 'enabledModules') do
  owner node[node['icingaweb2']['web_engine']]['user']
  group node[node['icingaweb2']['web_engine']]['group']
  mode '02770'
end

directory ::File.join(node['icingaweb2']['conf_dir'], 'modules', 'monitoring') do
  owner node[node['icingaweb2']['web_engine']]['user']
  group node[node['icingaweb2']['web_engine']]['group']
  mode '02770'
end

directory node['icingaweb2']['log_dir'] do
  owner node[node['icingaweb2']['web_engine']]['user']
  group node[node['icingaweb2']['web_engine']]['group']
  mode '02775'
end

# setup token
unless node['icingaweb2']['setup_config']
  unless node['icingaweb2'].key?('setup_token')
    require 'securerandom'
    node.normal['icingaweb2']['setup_token'] = SecureRandom.base64(12)
  end

  file ::File.join(node['icingaweb2']['conf_dir'], 'setup.token') do
    content node['icingaweb2']['setup_token']
    owner node[node['icingaweb2']['web_engine']]['user']
    group node[node['icingaweb2']['web_engine']]['group']
    mode 0o660
  end
end
