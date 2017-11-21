# frozen_string_literal: true
require 'spec_helper'

describe 'icingaweb2::default' do
  before do
    stub_command('/usr/sbin/httpd -t').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('which php').and_return(true)
  end

  shared_examples_for 'icingaweb2' do
    context 'all_platforms' do
      %w[apache ido install packages].each do |r|
        it "include recipe icingaweb2::#{r}" do
          expect(chef_run).to include_recipe("icingaweb2::#{r}")
        end
      end

      it 'install package icingaweb2' do
        expect(chef_run).to install_package('icingaweb2')
      end

      it 'install package icinga2-ido-mysql' do
        expect(chef_run).to install_package('icinga2-ido-mysql')
      end

      it 'create file /etc/icingaweb2/setup.token' do
        expect(chef_run).to create_file('/etc/icingaweb2/setup.token')
      end
    end
  end

  shared_context 'rhel_family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.8') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.normal['icingaweb2']['install_method'] = 'package'
        node.normal['icingaweb2']['ignore_version'] = true
      end.converge(described_recipe)
    end

    include_examples 'icingaweb2'

    it 'install package icingacli' do
      expect(chef_run).to install_package('icingacli')
    end

    %w[/var/log/icingaweb2].each do |d|
      it "creates directory #{d}" do
        expect(chef_run).to create_directory(d).with(
          owner: 'apache',
          group: 'apache'
        )
      end
    end

    %w[/etc/icingaweb2].each do |d|
      it "creates directory #{d}" do
        expect(chef_run).to create_directory(d).with(
          owner: 'apache',
          group: 'apache'
        )
      end
    end

    it 'adds icinga2-release repository' do
      expect(chef_run).to create_yum_repository('icinga2-release')
    end

    it 'adds icinga2-snapshot repository' do
      expect(chef_run).to create_yum_repository('icinga2-snapshot')
    end

    %w[gcc gcc-c++ glibc glibc-common mailx php php-devel gd gd-devel libjpeg libjpeg-devel libpng libpng-devel php-gd php-fpm php-cli php-pear php-xmlrpc php-xsl php-pdo php-soap php-ldap php-mysql php-pgsql php-intl php-pecl-imagick].each do |p|
      it "install packages #{p}" do
        expect(chef_run).to install_package(p)
      end
    end
  end

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.8') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.normal['icingaweb2']['install_method'] = 'package'
        node.normal['icingaweb2']['ignore_version'] = true
      end.converge(described_recipe)
    end

    include_context 'rhel_family'
  end

  context 'amazon' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2017.03') do |node|
        node.automatic['platform_family'] = 'amazon'
        node.automatic['platform'] = 'amazon'
        node.normal['icingaweb2']['install_method'] = 'package'
        node.normal['icingaweb2']['ignore_version'] = true
      end.converge(described_recipe)
    end

    include_context 'rhel_family'
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'ubuntu'
        node.automatic['lsb']['codename'] = 'trusty'
        node.normal['icingaweb2']['install_method'] = 'package'
        node.normal['icingaweb2']['ignore_version'] = true
      end.converge(described_recipe)
    end

    include_examples 'icingaweb2'

    %w[/etc/icingaweb2 /var/log/icingaweb2].each do |d|
      it "creates icingaweb2 directory #{d}" do
        expect(chef_run).to create_directory(d).with(
          owner: 'www-data',
          group: 'www-data'
        )
      end
    end

    it 'adds icinga2-release apt repository' do
      expect(chef_run).to add_apt_repository('icinga2-release')
    end

    it 'remove icinga2-snapshot apt repository' do
      expect(chef_run).to remove_apt_repository('icinga2-snapshot')
    end

    %w[g++ mailutils build-essential libgd2-xpm-dev libjpeg62 libpng12-0 libpng12-dev imagemagick].each do |p|
      it "install packages #{p}" do
        expect(chef_run).to install_package(p)
      end
    end
  end
end
