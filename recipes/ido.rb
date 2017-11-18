# frozen_string_literal: true
#
# Cookbook Name:: icingaweb2
# Recipe:: ido
#
# Copyright 2014, Virender Khatri
#

# Note: User need to create DB database, user with grants.

# validate ido
raise "incorrect ido #{node['icingaweb2']['ido']['type']}, valid are mysql pgsql" unless %w[mysql pgsql].include?(node['icingaweb2']['ido']['type'])

# install icinga2 ido package
package "icinga2-ido-#{node['icingaweb2']['ido']['type']}" do
  version node['icingaweb2']['version']['icinga2-ido'] + node['icingaweb2']['version_suffix'] unless node['icingaweb2']['ignore_version']
end

# disable ido-mysql default feature
icinga2_feature 'ido-mysql' do
  action :disable
end

if node['icingaweb2']['ido']['install_mysql_client']
  case node['platform_family']
  when 'debian'
    apt_repository 'icinga2-mysql-community' do
      uri node['icingaweb2']['ido']['apt']['uri']
      distribution node['icingaweb2']['ido']['apt']['distribution']
      components node['icingaweb2']['ido']['apt']['components']
      keyserver node['icingaweb2']['ido']['apt']['keyserver'] unless node['icingaweb2']['apt']['keyserver'].nil?
      key node['icingaweb2']['ido']['apt']['key']
      deb_src node['icingaweb2']['ido']['apt']['deb_src']
      action node['icingaweb2']['ido']['apt']['action']
    end
  when 'fedora', 'rhel', 'amazon'
    yum_repository 'icinga2-mysql-community' do
      description node['icingaweb2']['ido']['yum']['description']
      baseurl node['icingaweb2']['ido']['yum']['baseurl']
      gpgcheck node['icingaweb2']['ido']['yum']['gpgcheck']
      gpgkey node['icingaweb2']['ido']['yum']['gpgkey']
      enabled node['icingaweb2']['ido']['yum']['enabled']
      action node['icingaweb2']['ido']['yum']['action']
    end
  end

  package 'mysql-community-client'
end

# load ido schema
execute 'schema_load_ido_mysql' do
  command "\
  mysql -h #{node['icingaweb2']['ido']['db_host']} \
  -P#{node['icingaweb2']['ido']['db_port']} \
  -u#{node['icingaweb2']['ido']['db_user']} \
  -p#{node['icingaweb2']['ido']['db_password']} \
  #{node['icingaweb2']['ido']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['ido']['type']}/schema/#{node['icingaweb2']['ido']['type']}.sql \
  && touch /etc/icinga2/schema_loaded_ido_mysql"
  creates '/etc/icinga2//schema_loaded_ido_mysql'
  environment 'MYSQL_HOME' => node['icingaweb2']['ido']['mysql_home']
  only_if { node['icingaweb2']['ido']['type'] == 'mysql' }
end

execute 'schema_load_ido_pgsql' do
  command "\
  su - postgres -c \"export PGPASSWORD=\'#{node['icingaweb2']['ido']['db_password']}\' && \
  psql -h #{node['icingaweb2']['ido']['db_host']}\
  -p #{node['icingaweb2']['ido']['db_port']} \
  -U #{node['icingaweb2']['ido']['db_user']}\
  -d #{node['icingaweb2']['ido']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['ido']['type']}/schema/#{node['icingaweb2']['ido']['type']}.sql \
  && export PGPASSWORD=\'\'\" \
  && touch /var/lib/pgsql/schema_loaded_ido_pgsql"
  creates '/var/lib/pgsql/schema_loaded_ido_pgsql'
  only_if { node['icingaweb2']['ido']['type'] == 'pgsql' }
end

# enable icinga2 ido
if node['icingaweb2']['ido']['type'] == 'mysql'
  icinga2_idomysqlconnection "ido-#{node['icingaweb2']['ido']['type']}" do
    host node['icingaweb2']['ido']['db_host']
    port node['icingaweb2']['ido']['db_port']
    user node['icingaweb2']['ido']['db_user']
    password node['icingaweb2']['ido']['db_password']
    database node['icingaweb2']['ido']['db_name']
  end
elsif node['icingaweb2']['ido']['type'] == 'pgsql'
  icinga2_idopgsqlconnection "ido-#{node['icingaweb2']['ido']['type']}" do
    host node['icingaweb2']['ido']['db_host']
    port node['icingaweb2']['ido']['db_port']
    user node['icingaweb2']['ido']['db_user']
    password node['icingaweb2']['ido']['db_password']
    database node['icingaweb2']['ido']['db_name']
  end
end
