# # encoding: utf-8

# Inspec test for recipe icinga2classicui::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('icinga2-common') do
  it { should be_installed }
end

describe package('icinga2-bin') do
  it { should be_installed }
end

describe file('/etc/icinga2/objects.d/idomysqlconnection.conf') do
  it { should exist }
end

if %w[redhat fedora amazon].include?(os[:family])
  describe package('icinga2') do
    it { should be_installed }
  end

  describe package('icinga2-libs') do
    it { should be_installed }
  end

  describe file('/etc/httpd/conf-available/icinga2-web2.conf') do
    it { should exist }
  end
else
  describe package('libicinga2') do
    it { should be_installed }
  end

  describe file('/etc/apache2/conf-available/icinga2-web2.conf') do
    it { should exist }
  end
end
