# frozen_string_literal: true

default['icingaweb2']['setup_epel'] = true
default['icingaweb2']['setup_config'] = false
default['icingaweb2']['ignore_version'] = false
default['icingaweb2']['install_method'] = 'package' # options: package, source
default['icingaweb2']['modules'] = %w[doc monitoring translation]
default['icingaweb2']['web_engine'] = 'apache'
default['icingaweb2']['source_url'] = 'https://github.com/Icinga/icingaweb2.git'
default['icingaweb2']['version']['icingaweb2'] = '2.4.2-1'
default['icingaweb2']['version']['icingacli'] = '2.4.2-1'
default['icingaweb2']['version']['icinga2-ido'] = '2.8.0-1'
default['icingaweb2']['web_root'] = '/usr/share/icingaweb2'
default['icingaweb2']['web_uri'] = '/icingaweb2'
default['icingaweb2']['conf_dir'] = '/etc/icingaweb2'
default['icingaweb2']['log_dir'] = '/var/log/icingaweb2'

case node['platform_family']
when 'fedora', 'rhel', 'amazon'
  default['icingaweb2']['user'] = 'icinga'
  default['icingaweb2']['group'] = 'icinga'
when 'debian'
  default['icingaweb2']['user'] = 'nagios'
  default['icingaweb2']['group'] = 'nagios'
end

# apache
default['icingaweb2']['apache_modules'] = value_for_platform(
  %w[debian raspbian] => { 'default' => %w[default mod_python mod_php mod_cgi mod_ssl mod_rewrite mpm_prefork] },
  %w[ubuntu] => { 'default' => %w[default mod_python mod_php mod_cgi mod_ssl mod_rewrite mpm_prefork],
                  '>= 16.04' => %w[default mod_python mod_cgi mod_ssl mod_rewrite mpm_prefork] },
  %w[centos redhat] => { '>= 7.0' => %w[default mod_wsgi mod_php mod_cgi mod_ssl mod_rewrite],
                         'default' => %w[default mod_python mod_php mod_cgi mod_ssl mod_rewrite] },
  %w[fedora amazon] => { 'default' => %w[default mod_python mod_php mod_cgi mod_ssl mod_rewrite] }
)

default['icingaweb2']['apache_web2_template'] = 'apache.vhost.icinga2_web2.erb'
default['icingaweb2']['apache_conf_cookbook'] = 'icingaweb2'

# version suffix
case node['platform']
when 'centos', 'redhat', 'fedora', 'amazon'
  default['icingaweb2']['version_suffix'] = value_for_platform(
    %w[centos redhat] => { 'default' => ".el#{node['platform_version'].split('.')[0]}.icinga" },
    'fedora' => { 'default' => ".fc#{node['platform_version']}.icinga" },
    'amazon' => { 'default' => '.el6.icinga' }
  )
when 'ubuntu', 'debian', 'raspbian'
  default['icingaweb2']['version_suffix'] = '.' + node['lsb']['codename'].to_s
end

default['icingaweb2']['db_type'] = 'mysql'

# db mysql
default['icingaweb2']['install_mysql_client'] = false
default['icingaweb2']['mysql_version'] = '5.7'
default['icingaweb2']['mysql_home'] = '/etc/mysql'

# icingaweb2 db
default['icingaweb2']['web2_db']['load_schema'] = false
default['icingaweb2']['web2_db']['db_host'] = 'localhost'
default['icingaweb2']['web2_db']['db_port'] = 3306
default['icingaweb2']['web2_db']['db_name'] = 'icingaweb2'
default['icingaweb2']['web2_db']['db_user'] = 'icingaweb2'
default['icingaweb2']['web2_db']['db_password'] = 'icingaweb2'

# icinga2 ido db
default['icingaweb2']['ido_db']['load_schema'] = false
default['icingaweb2']['ido_db']['db_host'] = 'localhost'
default['icingaweb2']['ido_db']['db_port'] = 3306
default['icingaweb2']['ido_db']['db_name'] = 'icinga'
default['icingaweb2']['ido_db']['db_user'] = 'icinga'
default['icingaweb2']['ido_db']['db_password'] = 'icinga'

# configure mysql official repo to install mysql client package
case node['platform_family']
when 'fedora', 'rhel', 'amazon'
  default['icingaweb2']['mysql_repo']['yum']['description'] = 'MySQL Community'
  default['icingaweb2']['mysql_repo']['yum']['gpgcheck'] = true
  default['icingaweb2']['mysql_repo']['yum']['enabled'] = true
  default['icingaweb2']['mysql_repo']['yum']['gpgkey'] = 'https://raw.githubusercontent.com/Icinga/chef-icinga2/master/files/default/mysql_pubkey.asc'
  default['icingaweb2']['mysql_repo']['yum']['action'] = :create
when 'raspbian', 'debian'
  default['icingaweb2']['mysql_repo']['apt']['repo'] = 'MySQL Community'
  default['icingaweb2']['mysql_repo']['apt']['keyserver'] = 'keyserver.ubuntu.com'
  default['icingaweb2']['mysql_repo']['apt']['deb_src'] = false
  default['icingaweb2']['mysql_repo']['apt']['action'] = :add
  default['icingaweb2']['mysql_repo']['apt']['uri'] = "http://repo.mysql.com/apt/#{node['platform']}/"
  default['icingaweb2']['mysql_repo']['apt']['distribution'] = node['lsb']['codename']
  default['icingaweb2']['mysql_repo']['apt']['key'] = '5072E1F5'
else
  default['icingaweb2']['mysql_repo']['apt'] = {}
  default['icingaweb2']['mysql_repo']['yum'] = {}
end
