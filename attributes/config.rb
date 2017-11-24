default['icingaweb2']['ini_config']['resources'].tap do |resources|
  resources['icingaweb_db']['type'] = 'db'
  resources['icingaweb_db']['db'] = 'mysql'
  resources['icingaweb_db']['host'] = 'localhost'
  resources['icingaweb_db']['port'] = '3306'
  resources['icingaweb_db']['dbname'] = 'icingaweb2'
  resources['icingaweb_db']['username'] = 'icingaweb2'
  resources['icingaweb_db']['password'] = 'icingaweb2'
  resources['icingaweb_db']['charset'] = ''
  resources['icingaweb_db']['persistent'] = '0'
  resources['icingaweb_db']['use_ssl'] = '0'

  resources['icinga_ido']['type'] = 'db'
  resources['icinga_ido']['db'] = 'mysql'
  resources['icinga_ido']['host'] = 'localhost'
  resources['icinga_ido']['port'] = '3306'
  resources['icinga_ido']['dbname'] = 'icinga'
  resources['icinga_ido']['username'] = 'icinga'
  resources['icinga_ido']['password'] = 'icinga'
  resources['icinga_ido']['charset'] = ''
  resources['icinga_ido']['persistent'] = '0'
  resources['icinga_ido']['use_ssl'] = '0'

end

# #
default['icingaweb2']['ini_config']['config'].tap do |config|
  config['global']['show_stacktraces'] = '1'
  config['global']['config_backend'] = 'db'
  config['global']['config_resource'] = 'icingaweb_db'

  config['logging']['log'] = 'syslog'
  config['logging']['level'] = 'ERROR'
  config['logging']['application'] = 'icingaweb2'

#  config['preferences']['type'] = 'db'
#  config['preferences']['resource'] = 'icingaweb_db'
end

default['icingaweb2']['ini_config']['authentication'].tap do |authentication|
  authentication['icingaweb2']['backend'] = 'db'
#  authentication['icingaweb2']['resource'] = 'icingaweb_db'
end

# default['icingaweb2']['ini_config']['groups'].tap do |grp|
#  grp['icingaweb2']['backend'] = 'db'
#  grp['icingaweb2']['resource'] = 'icingaweb_db'
# end

default['icingaweb2']['ini_config']['roles'].tap do |roles|
  roles['Administrators']['users'] = 'icingaadmin'
  roles['Administrators']['permissions'] = '*'
  roles['Administrators']['groups'] = 'Administrators'
end

default['icingaweb2']['ini_config']['modules_monitoring_config'].tap do |mmc|
  mmc['security']['protected_customvars'] = '*pw*,*pass*,community'
end

default['icingaweb2']['ini_config']['modules_monitoring_backends'].tap do |mmb|
  mmb['icinga2']['type'] = 'ido'
  mmb['icinga2']['resource'] = 'icinga_ido'
end

default['icingaweb2']['ini_config']['modules_monitoring_commandtransports'].tap do |mmctr|
  mmctr['icinga2']['transport'] = 'local'
  mmctr['icinga2']['path'] = '/var/run/icinga2/cmd/icinga2.cmd'
#  mmctr['icinga2']['transport'] = 'api'
#  mmctr['icinga2']['host'] = 'localhost'
#  mmctr['icinga2']['port'] = '5665'
#  mmctr['icinga2']['username'] = 'api'
#  mmctr['icinga2']['password'] = 'api'
end
