# frozen_string_literal: true
#
# Cookbook Name:: icingaweb2
# Recipe:: ido
#
# Copyright 2014, Virender Khatri
#

# Note: User need to create DB database, user with grants.

# validate ido
raise "incorrect ido #{node['icingaweb2']['db_type']}, valid are mysql pgsql" unless %w[mysql pgsql].include?(node['icingaweb2']['db_type'])

# install icinga2 ido package
package "icinga2-ido-#{node['icingaweb2']['db_type']}" do
  version node['icingaweb2']['version']['icinga2-ido'] + node['icingaweb2']['version_suffix'] unless node['icingaweb2']['ignore_version']
end

if node['icingaweb2']['install_mysql_client']
  case node['platform_family']
  when 'debian'
    apt_repository 'icinga2-mysql-community' do
      uri node['icingaweb2']['mysql_repo']['apt']['uri']
      distribution node['icingaweb2']['mysql_repo']['apt']['distribution']
      components node['icingaweb2']['mysql_repo']['apt']['components']
      keyserver node['icingaweb2']['mysql_repo']['apt']['keyserver'] unless node['icingaweb2']['mysql_repo']['apt']['keyserver'].nil?
      key node['icingaweb2']['mysql_repo']['apt']['key']
      deb_src node['icingaweb2']['mysql_repo']['apt']['deb_src']
      action node['icingaweb2']['mysql_repo']['apt']['action']
    end
  when 'fedora', 'rhel', 'amazon'
    yum_repository 'icinga2-mysql-community' do
      description node['icingaweb2']['mysql_repo']['yum']['description']
      baseurl node['icingaweb2']['mysql_repo']['yum']['baseurl']
      gpgcheck node['icingaweb2']['mysql_repo']['yum']['gpgcheck']
      gpgkey node['icingaweb2']['mysql_repo']['yum']['gpgkey']
      enabled node['icingaweb2']['mysql_repo']['yum']['enabled']
      action node['icingaweb2']['mysql_repo']['yum']['action']
    end
  end

  package 'mysql-community-client'
end

# load icinga2 ido schema
execute 'schema_load_ido_mysql' do
  command "\
  mysql -h #{node['icingaweb2']['ido_db']['db_host']} \
  -P#{node['icingaweb2']['ido_db']['db_port']} \
  -u#{node['icingaweb2']['ido_db']['db_user']} \
  -p#{node['icingaweb2']['ido_db']['db_password']} \
  #{node['icingaweb2']['ido_db']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['db_type']}/schema/#{node['icingaweb2']['db_type']}.sql \
  && touch /etc/icinga2/schema_loaded_ido_mysql"
  creates '/etc/icinga2//schema_loaded_ido_mysql'
  environment 'MYSQL_HOME' => node['icingaweb2']['mysql_home']
  only_if { node['icingaweb2']['db_type'] == 'mysql' && node['icingaweb2']['ido_db']['load_schema'] }
end

execute 'schema_load_ido_pgsql' do
  command "\
  su - postgres -c \"export PGPASSWORD=\'#{node['icingaweb2']['ido_db']['db_password']}\' && \
  psql -h #{node['icingaweb2']['ido_db']['db_host']}\
  -p #{node['icingaweb2']['ido_db']['db_port']} \
  -U #{node['icingaweb2']['ido_db']['db_user']}\
  -d #{node['icingaweb2']['ido_db']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['db_type']}/schema/#{node['icingaweb2']['db_type']}.sql \
  && export PGPASSWORD=\'\'\" \
  && touch /var/lib/pgsql/schema_loaded_ido_pgsql"
  creates '/var/lib/pgsql/schema_loaded_ido_pgsql'
  only_if { node['icingaweb2']['db_type'] == 'pgsql' && node['icingaweb2']['ido_db']['load_schema'] }
end

# load icingaweb2 schema
remote_file "icingaweb2_schema_file_#{node['icingaweb2']['db_type']}" do
  path "/usr/share/icinga2-ido-#{node['icingaweb2']['db_type']}/schema/#{node['icingaweb2']['db_type']}.schema.sql"
  source "https://raw.githubusercontent.com/Icinga/icingaweb2/master/etc/schema/#{node['icingaweb2']['db_type']}.schema.sql"
  owner node['apache']['user']
  group node['apache']['group']
  mode 0o444
end

execute 'schema_load_icingaweb2_mysql' do
  command "\
  mysql -h #{node['icingaweb2']['web2_db']['db_host']} \
  -P#{node['icingaweb2']['web2_db']['db_port']} \
  -u#{node['icingaweb2']['web2_db']['db_user']} \
  -p#{node['icingaweb2']['web2_db']['db_password']} \
  #{node['icingaweb2']['web2_db']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['db_type']}/schema/#{node['icingaweb2']['db_type']}.schema.sql \
  && touch /etc/icinga2/schema_loaded_web2_mysql"
  creates '/etc/icinga2//schema_loaded_web2_mysql'
  environment 'MYSQL_HOME' => node['icingaweb2']['mysql_home']
  only_if { node['icingaweb2']['db_type'] == 'mysql' }
end

execute 'schema_load_icingaweb2_pgsql' do
  command "\
  su - postgres -c \"export PGPASSWORD=\'#{node['icingaweb2']['web2_db']['db_password']}\' && \
  psql -h #{node['icingaweb2']['web2_db']['db_host']}\
  -p #{node['icingaweb2']['web2_db']['db_port']} \
  -U #{node['icingaweb2']['web2_db']['db_user']}\
  -d #{node['icingaweb2']['web2_db']['db_name']} < /usr/share/icinga2-ido-#{node['icingaweb2']['db_type']}/schema/#{node['icingaweb2']['db_type']}.schema.sql \
  && export PGPASSWORD=\'\'\" \
  && touch /var/lib/pgsql/schema_loaded_web2_pgsql"
  creates '/var/lib/pgsql/schema_loaded_web2_pgsql'
  only_if { node['icingaweb2']['db_type'] == 'pgsql' }
end

# enable icinga2 ido
if node['icingaweb2']['db_type'] == 'mysql'
  icinga2_feature 'ido-mysql' do
    action :disable
  end

  icinga2_idomysqlconnection "ido-#{node['icingaweb2']['db_type']}" do
    host node['icingaweb2']['ido_db']['db_host']
    port node['icingaweb2']['ido_db']['db_port']
    user node['icingaweb2']['ido_db']['db_user']
    password node['icingaweb2']['ido_db']['db_password']
    database node['icingaweb2']['ido_db']['db_name']
  end
elsif node['icingaweb2']['db_type'] == 'pgsql'
  icinga2_feature 'ido-pgsql' do
    action :disable
  end

  icinga2_idopgsqlconnection "ido-#{node['icingaweb2']['db_type']}" do
    host node['icingaweb2']['ido_db']['db_host']
    port node['icingaweb2']['ido_db']['db_port']
    user node['icingaweb2']['ido_db']['db_user']
    password node['icingaweb2']['ido_db']['db_password']
    database node['icingaweb2']['ido_db']['db_name']
  end
end
