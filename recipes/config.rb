#
# Cookbook:: icingaweb2
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

template ::File.join(node['icingaweb2']['conf_dir'], 'resources.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['resources'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'config.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['config'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'authentication.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['authentication'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'roles.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['roles'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'modules', 'monitoring', 'config.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['modules_monitoring_config'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'modules', 'monitoring', 'backends.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['modules_monitoring_backends'])
  mode 0o660
end

template ::File.join(node['icingaweb2']['conf_dir'], 'modules', 'monitoring', 'commandtransports.ini') do
  source 'ini.erb'
  owner node['apache']['user']
  group node['apache']['group']
  notifies platform?('windows') ? :restart : :reload, 'service[apache2]', :delayed
  variables(:config => node['icingaweb2']['ini_config']['modules_monitoring_commandtransports'])
  mode 0o660
end

node['icingaweb2']['modules'].each do |mod|
  link ::File.join(node['icingaweb2']['conf_dir'], 'enabledModules', mod) do
    to "/usr/share/icingaweb2/modules/#{mod}"
  end
end
