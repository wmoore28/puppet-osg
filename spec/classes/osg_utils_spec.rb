require 'spec_helper'

describe 'osg::utils' do
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

      let(:params) {{ }}

      it { should compile.with_all_deps }
      it { should create_class('osg::utils') }
      it { should contain_class('osg::params') }
      it { should contain_class('osg') }

      it do
        # Expect utils + yum priorities plugin
        is_expected.to have_package_resource_count(3)
      end

      [
        'globus-proxy-utils',
        'osg-pki-tools',
      ].each do |p|
        it do
          is_expected.to contain_package(p).with({
            :ensure  => 'present',
            :require => 'Class[Osg::Repos]',
          })
        end
      end

    end
  end
end
