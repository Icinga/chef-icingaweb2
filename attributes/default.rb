# frozen_string_literal: true

default['icingaweb2']['setup_epel'] = true
default['icingaweb2']['ignore_version'] = false
default['icingaweb2']['install_method'] = 'package' # options: package, source
default['icingaweb2']['web_engine'] = 'apache'
default['icingaweb2']['source_url'] = 'https://github.com/Icinga/icingaweb2.git'
default['icingaweb2']['version']['icingaweb2'] = '2.4.2-1'
default['icingaweb2']['version']['icingacli'] = '2.4.2-1'
default['icingaweb2']['version']['icinga2-ido'] = '2.7.2-1'
default['icingaweb2']['web_root'] = '/usr/share/icingaweb2'
default['icingaweb2']['web_uri'] = '/icingaweb2'
default['icingaweb2']['conf_dir'] = '/etc/icingaweb2'
default['icingaweb2']['log_dir'] = '/var/log/icingaweb2'

case node['platform_family']
when 'fedora', 'rhel', 'amazon'
  default['icingaweb2']['user'] = 'icinga'
  default['icingaweb2']['group'] = 'icinga'
  default['icingaweb2']['cmdgroup'] = 'icingacmd'
  default['icingaweb2']['plugins_dir'] = if node['kernel']['machine'] == 'x86_64'
                                           '/usr/lib64/nagios/plugins'
                                         else
                                           '/usr/lib/nagios/plugins'
                                         end

when 'debian'
  default['icingaweb2']['user'] = 'nagios'
  default['icingaweb2']['group'] = 'nagios'
  default['icingaweb2']['cmdgroup'] = 'nagios'
  default['icingaweb2']['plugins_dir'] = '/usr/lib/nagios/plugins'
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

default['icingaweb2']['apache_classic_ui_template'] = "apache.vhost.icinga2_classic_ui.conf.#{node['platform_family']}.erb"
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
  default['icingaweb2']['version_suffix'] = '~' + node['lsb']['codename'].to_s
end

# ido
default['icingaweb2']['ido']['load_schema'] = false
default['icingaweb2']['ido']['install_mysql_client'] = false

default['icingaweb2']['ido']['type'] = 'mysql'
default['icingaweb2']['ido']['db_host'] = 'localhost'
default['icingaweb2']['ido']['db_port'] = 3306
default['icingaweb2']['ido']['db_name'] = 'icinga'
default['icingaweb2']['ido']['db_user'] = 'icinga'
default['icingaweb2']['ido']['db_password'] = 'icinga'
default['icingaweb2']['ido']['mysql_home'] = '/etc/mysql'

# configure mysql official repo to install mysql client package
default['icingaweb2']['ido']['mysql_version'] = '5.7'

case node['platform_family']
when 'fedora', 'rhel', 'amazon'
  default['icingaweb2']['ido']['yum']['description'] = "MySQL Community #{node['icingaweb2']['ido']['mysql_version']}"
  default['icingaweb2']['ido']['yum']['gpgcheck'] = true
  default['icingaweb2']['ido']['yum']['enabled'] = true
  default['icingaweb2']['ido']['yum']['gpgkey'] = 'https://raw.githubusercontent.com/Icinga/chef-icinga2/master/files/default/mysql_pubkey.asc'
  default['icingaweb2']['ido']['yum']['action'] = :create
  default['icingaweb2']['ido']['yum']['baseurl'] = value_for_platform(
    %w[centos redhat] => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['ido']['mysql_version']}-community/el/#{node['platform_version'].split('.')[0]}/$basearch/" },
    'fedora' => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['ido']['mysql_version']}-community/fedora/#{node['platform_version'].split('.')[0]}/$basearch/" },
    'amazon' => { 'default' => "http://repo.mysql.com/yum/mysql-#{node['icingaweb2']['ido']['mysql_version']}-community/el/6/$basearch/" }
  )
when 'raspbian', 'debian'
  default['icingaweb2']['ido']['apt']['repo'] = "MySQL Community #{node['icingaweb2']['ido']['mysql_version']}"
  default['icingaweb2']['ido']['apt']['keyserver'] = 'keyserver.ubuntu.com'
  default['icingaweb2']['ido']['apt']['components'] = ["mysql-#{node['icingaweb2']['ido']['mysql_version']}"]
  default['icingaweb2']['ido']['apt']['deb_src'] = false
  default['icingaweb2']['ido']['apt']['action'] = :add
  default['icingaweb2']['ido']['apt']['repo'] = "MySQL Community #{node['icingaweb2']['ido']['mysql_version']}"
  default['icingaweb2']['ido']['apt']['uri'] = "http://repo.mysql.com/apt/#{node['platform']}/"
  default['icingaweb2']['ido']['apt']['distribution'] = node['lsb']['codename']
  default['icingaweb2']['ido']['apt']['key'] = '5072E1F5'
else
  default['icingaweb2']['ido']['apt'] = {}
  default['icingaweb2']['ido']['yum'] = {}
end
