require 'spec_helper'

describe 'osg::fetchcrl' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { should compile.with_all_deps }
      it { should create_class('osg::fetchcrl') }
      it { should contain_class('osg::params') }
      it { should contain_class('osg') }
      #it { should contain_class('cron') }

      it do 
        should contain_package('fetch-crl').with({
          :ensure   => 'installed',
          :name     => 'fetch-crl',
          :require  => 'Yumrepo[osg]',
        })
      end

      it do
        should contain_file('/etc/fetch-crl.d/syslog.conf').with({
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
        })
      end

      it do
        should contain_service('fetch-crl-boot').with({
          :ensure       => 'stopped',
          :enable       => 'false',
          :name         => 'fetch-crl-boot',
          :hasstatus    => 'true',
          :hasrestart   => 'true',
          :require      => 'Package[fetch-crl]',
        })
      end

      it do
        should contain_service('fetch-crl-cron').with({
          :ensure       => 'running',
          :enable       => 'true',
          :name         => 'fetch-crl-cron',
          :hasstatus    => 'true',
          :hasrestart   => 'true',
          :require      => 'Package[fetch-crl]',
        })
      end

      context "with ensure => 'absent'" do
        let(:params) {{ :ensure => 'absent' }}
        it { should contain_package('fetch-crl').with_ensure('absent') }
        it { should contain_file('/etc/fetch-crl.d/syslog.conf').with_ensure('absent') }
        it { should contain_service('fetch-crl-boot').with_ensure('stopped') }
        it { should contain_service('fetch-crl-boot').with_enable('false') }
        it { should contain_service('fetch-crl-cron').with_ensure('stopped') }
        it { should contain_service('fetch-crl-cron').with_enable('false') }
      end

      context "with ensure => 'disabled'" do
        let(:params) {{ :ensure => 'disabled' }}
        it { should contain_package('fetch-crl').with_ensure('installed') }
        it { should contain_file('/etc/fetch-crl.d/syslog.conf').with_ensure('file') }
        it { should contain_service('fetch-crl-boot').with_ensure('stopped') }
        it { should contain_service('fetch-crl-boot').with_enable('false') }
        it { should contain_service('fetch-crl-cron').with_ensure('stopped') }
        it { should contain_service('fetch-crl-cron').with_enable('false') }
      end

    end
  end
end
