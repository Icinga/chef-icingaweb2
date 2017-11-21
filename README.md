icingaweb2 Cookbook
================

[![Cookbook](https://img.shields.io/github/tag/Icinga/chef-icingaweb2.svg)](https://github.com/Icinga/chef-icingaweb2) [![Build Status](https://travis-ci.org/Icinga/chef-icingaweb2.svg?branch=master)](https://travis-ci.org/Icinga/chef-icingaweb2)

[Icinga Logo](https://www.icinga.com/wp-content/uploads/2014/06/icinga_logo.png)

This is a [Chef] cookbook to manage [Icingaweb2].


>> For Production environment, always prefer the [most recent release](https://supermarket.chef.io/cookbooks/icingaweb2).


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
https://github.com/Icinga/icingaweb2
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

- `icingaweb2::install` - install icingaweb2 packages

- `icingaweb2::ido` - configure icinga2 mysql ido

- `icingaweb2::packages` - install icingaweb2 dependencies

- `icingaweb2::apache` - configure apache web server

- `icingaweb2::default` - run_list recipe


## Cookbook Attributes

 * `default['icingaweb2']['setup_epel']` (default: `true`): if set includes recipe `yum-epel`

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

 * `default['icingaweb2']['ido']['type']` (default: `mysql`): icinga2 ido type, valid are `mysql pgsql`

 * `default['icingaweb2']['ido']['load_schema']` (default: `false`): whether to load db schema

 * `default['icingaweb2']['ido']['install_mysql_client']` (default: `false`): install mysql client using mysql official repository

 * `default['icingaweb2']['ido']['db_host']` (default: `localhost`): icingaweb2 ido db host

 * `default['icingaweb2']['ido']['db_port']` (default: `3306`): icingaweb2 ido db port

 * `default['icingaweb2']['ido']['db_name']` (default: `icinga`): icingaweb2 ido db name

 * `default['icingaweb2']['ido']['db_user']` (default: `icinga`): icingaweb2 ido db user

 * `default['icingaweb2']['ido']['db_password']` (default: `icinga`): icingaweb2 ido db password

 * `default['icingaweb2']['ido']['mysql_home']` (default: `/etc/mysql`): sets value for environment variable `MYSQL_HOME` for schema load

 * `default['icingaweb2']['ido']['mysql_version']` (default: `5.7`): install mysql client if set true

 * `default['icingaweb2']['ido']['yum']['description']` (default: `MySQL Community #{node['icingaweb2']['ido']['mysql_version']}`): yum repo resource attribute

 * `default['icingaweb2']['ido']['yum']['gpgcheck']` (default: `true`): yum repo resource attribute

 * `default['icingaweb2']['ido']['yum']['enabled']` (default: `true`): yum repo resource attribute

 * `default['icingaweb2']['ido']['yum']['gpgkey']` (default: `https://raw.githubusercontent.com/Icinga/chef-icinga2/master/files/default/mysql_pubkey.asc`): yum repo resource attribute

 * `default['icingaweb2']['ido']['yum']['action']` (default: `:create`): yum repo resource attribute

 * `default['icingaweb2']['ido']['yum']['baseurl']` (default: `calculated`): yum repo resource attribute

 * `default['icingaweb2']['ido']['apt']['repo']` (default: `MySQL Community #{node['icingaweb2']['ido']['mysql_version']}`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['keyserver']` (default: `keyserver.ubuntu.com`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['components']` (default: `["mysql-#{node['icingaweb2']['ido']['mysql_version']}"]`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['deb_src']` (default: `false`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['action']` (default: `:add`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['repo']` (default: `MySQL Community #{node['icingaweb2']['ido']['mysql_version']}`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['uri']` (default: `http://repo.mysql.com/apt/#{node['platform']}/`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['distribution']` (default: `node['lsb']['codename']`): apt repository resource attribute

 * `default['icingaweb2']['ido']['apt']['key']` (default: `5072E1F5`): apt repository resource attribute


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
