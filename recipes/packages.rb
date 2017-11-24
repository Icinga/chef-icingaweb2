#
# Cookbook:: icingaweb2
# Recipe:: packages
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

os_packages = []

case node['platform_family']
when 'debian'
  case node['lsb']['codename']
  when 'trusty'
    # package libjpeg62-dev conflicts with libgd2-xpm-dev
    # perhaps can be removed.
    os_packages = %w[g++ mailutils php5 php5-cli php5-fpm build-essential
                     libgd2-xpm-dev libjpeg62 libpng12-0
                     libpng12-dev imagemagick
                     php5-imagick php-pear php5-xmlrpc php5-xsl php5-mysql
                     php-soap php5-gd php5-ldap php5-pgsql php5-intl]

  when 'xenial'
    os_packages = %w[apt-utils g++ mailutils libapache2-mod-php7.0 php7.0 php7.0-cli php7.0-fpm build-essential
                     libgd2-xpm-dev libjpeg62 libpng12-0
                     libpng12-dev imagemagick
                     php7.0-imagick php-pear php7.0-xmlrpc php7.0-xsl php7.0-mysql
                     php-soap php7.0-gd php7.0-ldap php7.0-pgsql php7.0-intl php7.0-curl]
  end

  apt_repository 'ondrej-php' do
    uri 'ppa:ondrej/php'
    distribution node['lsb']['codename']
    only_if { node['lsb']['codename'] == 'xenial' } # That's Ubuntu 16
  end

  include_recipe 'apt'

  os_packages.push('git-core') if node['icingaweb2']['install_method'] == 'source'

when 'fedora', 'rhel', 'amazon'
  os_packages = %w[gcc gcc-c++ glibc glibc-common mailx php php-devel gd
                   gd-devel libjpeg libjpeg-devel libpng libpng-devel php-gd
                   php-fpm php-cli php-pear php-xmlrpc php-xsl php-pdo
                   php-soap php-ldap php-mysql php-pgsql php-intl php-pecl-imagick]
  # yum epel repository is required for mod_python, php-pecl-imagick
  include_recipe 'yum-epel' if node['platform'] != 'amazon' && node['icingaweb2']['setup_epel']
  os_packages.push('git') if node['icingaweb2']['install_method'] == 'source'
end

os_packages.each do |p|
  package p
end
