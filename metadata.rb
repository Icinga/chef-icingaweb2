name 'icingaweb2'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures IcingaWeb2'
long_description 'Installs/Configures IcingaWeb2'
version '1.0.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url 'https://github.com/Icinga/chef-icingaweb2/issues' if respond_to?(:issues_url)
source_url 'https://github.com/Icinga/chef-icingaweb2' if respond_to?(:source_url)

depends 'apache2', '~> 3.3.0'
depends 'yum-epel', '>= 2.1.1'
depends 'apt', '>= 5.0.1'
depends 'icinga2repo', '>= 1.0.0'
depends 'icinga2', '>= 4.0.0'

%w[redhat centos amazon ubuntu].each do |os|
  supports os
end
