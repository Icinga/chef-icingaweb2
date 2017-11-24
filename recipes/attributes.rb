#
# Cookbook:: icingaweb2
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

case node['platform_family']
when 'fedora', 'rhel', 'amazon'
  node.default['icingaweb2']['mysql_repo']['yum']['baseurl'] = value_for_platform(
    %w[centos redhat] => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['mysql_version']}-community/el/#{node['platform_version'].split('.')[0]}/$basearch/" },
    'fedora' => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['mysql_version']}-community/fedora/#{node['platform_version'].split('.')[0]}/$basearch/" },
    'amazon' => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['mysql_version']}-community/el/6/$basearch/" }
  )
when 'raspbian', 'debian'
  node.default['icingaweb2']['mysql_repo']['apt']['components'] = ["mysql-#{node['icingaweb2']['mysql_version']}"]
end
