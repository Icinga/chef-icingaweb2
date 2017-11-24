default['icingaweb2']['ini_config']['resources'].tap do |resources|
  resources['icingaweb2']['type'] = 'db'
  resources['icingaweb2']['db'] = 'mysql'
  resources['icingaweb2']['host'] = 'localhost'
  resources['icingaweb2']['port'] = '3306'
  resources['icingaweb2']['dbname'] = 'icingaweb2'
  resources['icingaweb2']['username'] = 'icingaweb2'
  resources['icingaweb2']['password'] = 'icingaweb2'

  resources['icinga2']['type'] = 'db'
  resources['icinga2']['db'] = 'mysql'
  resources['icinga2']['host'] = 'localhost'
  resources['icinga2']['port'] = '3306'
  resources['icinga2']['dbname'] = 'icinga'
  resources['icinga2']['username'] = 'icinga'
  resources['icinga2']['password'] = 'icinga'
end

default['icingaweb2']['ini_config']['config'].tap do |config|
  config['logging']['log'] = 'syslog'
  config['logging']['level'] = 'ERROR'
  config['logging']['application'] = 'icingaweb2'

  config['preferences']['type'] = 'db'
  config['preferences']['resource'] = 'icingaweb2'
end

default['icingaweb2']['ini_config']['authentication'].tap do |authentication|
  authentication['icingaweb2']['backend'] = 'db'
  authentication['icingaweb2']['resource'] = 'icingaweb2'
end

default['icingaweb2']['ini_config']['roles'].tap do |roles|
  roles['admins']['users'] = 'icingaadmin'
  roles['admins']['permissions'] = '*'
end

default['icingaweb2']['ini_config']['modules_monitoring_config'].tap do |mmc|
  mmc['security']['protected_customvars'] = '*pw*,*pass*,community'
end

default['icingaweb2']['ini_config']['modules_monitoring_backends'].tap do |mmb|
  mmb['icinga2']['type'] = 'ido'
  mmb['icinga2']['resource'] = 'icinga2'
end

default['icingaweb2']['ini_config']['modules_monitoring_commandtransports'].tap do |mmctr|
  mmctr['icinga2']['transport'] = 'api'
  mmctr['icinga2']['host'] = 'localhost'
  mmctr['icinga2']['port'] = '5665'
  mmctr['icinga2']['username'] = 'api'
  mmctr['icinga2']['password'] = 'api'
end
