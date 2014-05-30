require 'spec_helper'

describe 'osg::ce' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:params) {{ }}

  it { should create_class('osg::ce') }
  it { should contain_class('osg::params') }
  it { should contain_class('osg') }
  it { should contain_class('osg::repo') }
  it { should contain_class('osg::cacerts') }
  it { should contain_class('osg::gums::client') }

  it { should contain_anchor('osg::ce::start').that_comes_before('Class[osg::repo]') }
  it { should contain_class('osg::repo').that_comes_before('Class[osg::cacerts]') }
  it { should contain_class('osg::cacerts').that_comes_before('Class[osg::ce::install]') }
  it { should contain_class('osg::ce::install').that_comes_before(nil) }
  it { should contain_class('osg::ce::config').that_comes_before('Class[osg::ce::service]') }
  it { should contain_class('osg::ce::service').that_comes_before('Anchor[osg::ce::end]') }
  it { should contain_anchor('osg::ce::end') }

  context 'osg::ce::install' do
    it do
      should contain_package('empty-torque').with({
        :ensure => 'present',
        :before => 'Package[osg-ce]',
      })
    end

    it do
      should contain_package('osg-ce').with({
        :ensure => 'present',
        :name   => 'osg-ce-pbs',
      })
    end

    it do
      should contain_package('osg-configure-slurm').with({
        :ensure   => 'present',
        :require  => 'Package[osg-ce]',
      })
    end
  end

  context 'osg::ce::config' do
    it do
      should contain_file('/etc/grid-security/hostcert.pem').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0444',
        :source => nil,
      })
    end

    it do
      should contain_file('/etc/grid-security/hostkey.pem').with({
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0400',
        :source => nil,
      })
    end

    it do
      should contain_file('/etc/grid-security/http').with({
        :ensure => 'directory',
        :owner  => 'tomcat',
        :group  => 'tomcat',
      })
    end

    it do
      should contain_file('/etc/grid-security/http/httpcert.pem').with({
        :ensure   => 'file',
        :owner    => 'tomcat',
        :group    => 'tomcat',
        :mode     => '0444',
        :source   => nil,
        :require  => 'File[/etc/grid-security/http]',
      })
    end

    it do
      should contain_file('/etc/grid-security/http/httpkey.pem').with({
        :ensure   => 'file',
        :owner    => 'tomcat',
        :group    => 'tomcat',
        :mode     => '0400',
        :source   => nil,
        :require  => 'File[/etc/grid-security/http]',
      })
    end

    it do
      should contain_file('/etc/grid-security/grid-mapfile').with({
        :ensure   => 'file',
        :owner    => 'root',
        :group    => 'root',
        :mode     => '0644',
        :source   => nil,
        :content  => nil,
      })
    end
  end

  context 'osg::ce::service' do
    it do
      should contain_service('globus-gatekeeper').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :before     => 'Service[globus-gridftp-server]', 
      })
    end

    it do
      should contain_service('globus-gridftp-server').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :before     => 'Service[tomcat6]', 
      })
    end

    it do
      should contain_service('tomcat6').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :before     => 'Service[gratia-probes-cron]', 
      })
    end

    it do
      should contain_service('gratia-probes-cron').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :before     => 'Service[osg-cleanup-cron]', 
      })
    end

    it do
      should contain_service('osg-cleanup-cron').with({
        :ensure     => 'running',
        :enable     => 'true',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :before     => nil, 
      })
    end
  end
end
