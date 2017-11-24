icingaweb2 Cookbook
================

[![Cookbook](https://img.shields.io/github/tag/Icinga/chef-icingaweb2.svg)](https://github.com/Icinga/chef-icingaweb2) [![Build Status](https://travis-ci.org/Icinga/chef-icingaweb2.svg?branch=master)](https://travis-ci.org/Icinga/chef-icingaweb2)

[Icinga Logo](https://www.icinga.com/wp-content/uploads/2014/06/icinga_logo.png)

This is a [Chef] cookbook to manage [Icingaweb2].


>> For Production environment, always prefer the [most recent release](https://supermarket.chef.io/cookbooks/icingaweb2).


## Icingaweb2 Setup

Currently, `icingaweb2` can only be configured by accessing `/icingaweb2/setup`.

Automated configuration is not fully tested. Check out Github open [Issues] for more information.


## Most Recent Release

```ruby
cookbook 'icingaweb2', '~> 1.0.0'
```


## From Git

```ruby
cookbook 'icingaweb2', github: 'Icinga/chef-icingaweb2',  tag: 'v1.0.0'
```


## Repository

```
https://github.com/Icinga/chef-icingaweb2
```


## Supported OS

- Amazon Linux
- CentOS
- Ubuntu


## Supported Chef

- Chef 12
- Chef 13


## Cookbook Dependency

- icinga2repo
- icinga2


## Recipes

- `icingaweb2::attributes` - icingaweb2 evaluated attributes

- `icingaweb2::install` - install icingaweb2 packages

- `icingaweb2::config` - icingaweb2 configuration files

- `icingaweb2::ido` - configure icinga2 ido packages and load db schema

- `icingaweb2::packages` - install icingaweb2 package dependencies

- `icingaweb2::apache` - configure apache web server

- `icingaweb2::default` - run_list recipe


## Prepare Database

This cookbook requires a running database server. Database setup is not part of this cookbook and must be setup separately.

### MySQL

When using MySQL Database, a database and database user must be created with proper privileges for `icinga2 ido` and `icingaweb2`.

```shell
e.g. icinga2 ido database
database name : icinga
database user: icinga
databasepassword: icinga

mysql> CREATE DATABASE icinga;
mysql> GRANT ALL PRIVILEGES ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';
mysql> FLUSH PRIVILEGES;
```

```shell
e.g. icingaweb2 database
database name : icingaweb2
database user: icingaweb2
databasepassword: icnigaweb2

mysql> CREATE DATABASE icingaweb2;
mysql> GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icingaweb2.* TO 'icingaweb2'@'localhost' IDENTIFIED BY 'icingaweb2';
mysql> FLUSH PRIVILEGES;

```

### PgSQL

TODO


## How to Load Database Schema

Set below attributes to `true` to load db schema using cookbook.

- default['icingaweb2']['ido_db']['load_schema']
- default['icingaweb2']['web2_db']['load_schema']


## Cookbook Attributes

 * `default['icingaweb2']['setup_epel']` (default: `true`): if set includes recipe `yum-epel`

 * `default['icingaweb2']['setup_config']` (default: `false`): [Experimental] if set creates ini configuration files and also enable modules

 * `default['icingaweb2']['modules']` (default: `%w[doc monitoring translation]`): enable icingaweb2 modules

 * `default['icingaweb2']['install_method']` (default: `package`): icingaweb2 install method, options: package, source

 * `default['icingaweb2']['source_url']` (default: `git://git.icinga.org/icingaweb2.git`):

 * `default['icingaweb2']['ignore_version']` (default: `false`): ignore icingaweb2 package version

 * `default['icingaweb2']['web_engine']` (default: `apache`): icingaweb2 web server

 * `default['icingaweb2']['version']['icingaweb2']` (default: `2.4.2-1`): icingaweb2 package version

 * `default['icingaweb2']['version']['icingacli']` (default: `2.4.2-1`): icingacli package version

 * `default['icingaweb2']['version']['icinga-ido']` (default: `2.8.0-1`): icinga-ido package version

 * `default['icingaweb2']['user']` (default: `calculated`): icingaweb2 user

 * `default['icingaweb2']['group']` (default: `calculated`): icingaweb2 user group

 * `default['icingaweb2']['web_root']` (default: `/usr/share/icingaweb2`): icingaweb2 web root location

 * `default['icingaweb2']['web_uri']` (default: `/icingaweb2`): icingweb2 web uri

 * `default['icingaweb2']['conf_dir']` (default: `/etc/icingaweb2`): icingaweb2 config directory

 * `default['icingaweb2']['log_dir']` (default: `/var/log/icingaweb2`): icingaweb2 log directory

 * `default['icingawe2']['apache_modules']` (default: `calculated`): apache2 modules

 * `default['icingawe2']['apache_web2_template']` (default: `apache.vhost.icinga2_web2.erb`): apache2 vhost config template file

 * `default['icingawe2']['apache_conf_cookbook']` (default: `icingaweb2`): resource cookbook name

 * `default['icingawe2']['version_suffix']` (default: `calculated`): icingaweb2 package version suffix

 * `default['icingaweb2']['mysql_home']` (default: `/etc/mysql`): sets value for environment variable `MYSQL_HOME` for schema load

 * `default['icingaweb2']['mysql_version']` (default: `5.7`): if set true, install mysql client

 * `default['icingaweb2']['install_mysql_client']` (default: `false`): install mysql client using mysql official repository

 * `default['icingaweb2']['db_type']` (default: `mysql`): icinga2 database type for ido and web2, options: `mysql pgsql`


## Icinga2 IDO Database Attributes

 * `default['icingaweb2']['ido_db']['load_schema']` (default: `false`): if set true, loads icinga2 ido db schema (`mysql.sql`)

 * `default['icingaweb2']['ido_db']['db_host']` (default: `localhost`): icinga2 ido db host

 * `default['icingaweb2']['ido_db']['db_port']` (default: `3306`): icinga2 ido db port

 * `default['icingaweb2']['ido_db']['db_name']` (default: `icinga`): icinga2 ido db name

 * `default['icingaweb2']['ido_db']['db_user']` (default: `icinga`): icinga2 ido db user

 * `default['icingaweb2']['ido_db']['db_password']` (default: `icinga`): icinga2 ido db password


## Icingaweb2 Database Attributes

  * `default['icingaweb2']['web2_db']['load_schema']` (default: `false`): if set true, loads icingaweb2 db schema (`mysql.schema.sql`)

  * `default['icingaweb2']['web2_db']['db_host']` (default: `localhost`): icingaweb2 db host

  * `default['icingaweb2']['web2_db']['db_port']` (default: `3306`): icingaweb2 db port

  * `default['icingaweb2']['web2_db']['db_name']` (default: `icingaweb2`): icingaweb2 db name

  * `default['icingaweb2']['web2_db']['db_user']` (default: `icingaweb2`): icingaweb2 db user

  * `default['icingaweb2']['web2_db']['db_password']` (default: `icingaweb2`): icingaweb2 db password


## Mysql Repository attributes

 * `default['icingaweb2']['mysql_repo']['yum']['description']` (default: `MySQL Community`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['yum']['gpgcheck']` (default: `true`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['yum']['enabled']` (default: `true`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['yum']['gpgkey']` (default: `https://raw.githubusercontent.com/Icinga/chef-icinga2/master/files/default/mysql_pubkey.asc`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['yum']['action']` (default: `:create`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['yum']['baseurl']` (default: `calculated`): yum repo resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['repo']` (default: `MySQL Community`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['keyserver']` (default: `keyserver.ubuntu.com`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['components']` (default: `calculated`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['deb_src']` (default: `false`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['action']` (default: `:add`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['uri']` (default: `http://repo.mysql.com/apt/#{node['platform']}/`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['distribution']` (default: `node['lsb']['codename']`): apt repository resource attribute

 * `default['icingaweb2']['mysql_repo']['apt']['key']` (default: `5072E1F5`): apt repository resource attribute


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake & rake knife`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[Chef]: https://www.chef.io/
[Icingaweb2]: https://www.icinga.com/
[Contributors]: https://github.com/Icinga/chef-icingaweb2/graphs/contributors
[Issues]: https://github.com/Icinga/chef-icingaweb2/issues
