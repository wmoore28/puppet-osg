require 'spec_helper'

describe 'osg::repos' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('osg::repos') }
  it { should contain_class('osg') }
  it { should contain_class('osg::params') }

  it { should contain_package('yum-plugin-priorities').with_ensure('present') }

  it do
    should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG').with({
      :ensure  => 'file',
      :source  => 'puppet:///modules/osg/RPM-GPG-KEY-OSG',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    should contain_gpg_key('osg').with({
      :path    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
    })
  end

  [
    {:name => 'osg', :path => 'release', :desc => '', :enabled => '1'},
    {:name => 'osg-contrib', :path => 'contrib', :desc => ' - Contributed', :enabled => '0'},
    {:name => 'osg-development', :path => 'development', :desc => ' - Development', :enabled => '0'},
    {:name => 'osg-testing', :path => 'testing', :desc => ' - Testing', :enabled => '0'},
  ].each do |h|
    it do
      should contain_yumrepo(h[:name]).only_with({
        :name           => h[:name],
        :baseurl        => 'absent',
        :mirrorlist     => "http://repo.grid.iu.edu/mirror/osg/3.1/el6/#{h[:path]}/x86_64",
        :descr          => "OSG Software for Enterprise Linux 6#{h[:desc]} - x86_64",
        :enabled        => h[:enabled],
        :failovermethod => 'priority',
        :gpgcheck       => '1',
        :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
        :priority       => '98',
        :require        => 'Gpg_key[osg]',
      })
    end
  end

  [
    {:name => 'osg-upcoming', :path => 'release', :desc => 'Upcoming'},
    {:name => 'osg-upcoming-development', :path => 'development', :desc => 'Upcoming Development'},
    {:name => 'osg-upcoming-testing', :path => 'testing', :desc => 'Upcoming Testing'},
  ].each do |h|
    it do
      should contain_yumrepo(h[:name]).only_with({
        :name           => h[:name],
        :baseurl        => 'absent',
        :mirrorlist     => "http://repo.grid.iu.edu/mirror/osg/upcoming/el6/#{h[:path]}/x86_64",
        :descr          => "OSG Software for Enterprise Linux 6 - #{h[:desc]} - x86_64",
        :enabled        => '0',
        :failovermethod => 'priority',
        :gpgcheck       => '1',
        :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
        :priority       => '98',
        :require        => 'Gpg_key[osg]',
      })
    end
  end

  context 'when repo_use_mirrors => false' do
    let(:pre_condition) { "class { 'osg': repo_use_mirrors => false }"}

    [
      {:name => 'osg', :path => 'release', :desc => '', :enabled => '1'},
      {:name => 'osg-contrib', :path => 'contrib', :desc => ' - Contributed', :enabled => '0'},
      {:name => 'osg-development', :path => 'development', :desc => ' - Development', :enabled => '0'},
      {:name => 'osg-testing', :path => 'testing', :desc => ' - Testing', :enabled => '0'},
    ].each do |h|
      it do
        should contain_yumrepo(h[:name]).only_with({
          :name           => h[:name],
          :baseurl        => "http://repo.grid.iu.edu/osg/3.1/el6/#{h[:path]}/x86_64",
          :mirrorlist     => 'absent',
          :descr          => "OSG Software for Enterprise Linux 6#{h[:desc]} - x86_64",
          :enabled        => h[:enabled],
          :failovermethod => 'priority',
          :gpgcheck       => '1',
          :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
          :priority       => '98',
          :require        => 'Gpg_key[osg]',
        })
      end
    end

    [
      {:name => 'osg-upcoming', :path => 'release', :desc => 'Upcoming'},
      {:name => 'osg-upcoming-development', :path => 'development', :desc => 'Upcoming Development'},
      {:name => 'osg-upcoming-testing', :path => 'testing', :desc => 'Upcoming Testing'},
    ].each do |h|
      it do
        should contain_yumrepo(h[:name]).only_with({
          :name           => h[:name],
          :baseurl        => "http://repo.grid.iu.edu/osg/upcoming/el6/#{h[:path]}/x86_64",
          :mirrorlist     => 'absent',
          :descr          => "OSG Software for Enterprise Linux 6 - #{h[:desc]} - x86_64",
          :enabled        => '0',
          :failovermethod => 'priority',
          :gpgcheck       => '1',
          :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
          :priority       => '98',
          :require        => 'Gpg_key[osg]',
        })
      end
    end

    context 'when repo_urlbit => "http://foo.example.com"' do
      let(:pre_condition) { "class { 'osg': repo_use_mirrors => false, repo_baseurl_bit => 'http://foo.example.com' }" }

      [
        {:name => 'osg', :path => 'release', :desc => '', :enabled => '1'},
        {:name => 'osg-contrib', :path => 'contrib', :desc => ' - Contributed', :enabled => '0'},
        {:name => 'osg-development', :path => 'development', :desc => ' - Development', :enabled => '0'},
        {:name => 'osg-testing', :path => 'testing', :desc => ' - Testing', :enabled => '0'},
      ].each do |h|
        it do
          should contain_yumrepo(h[:name]).only_with({
            :name           => h[:name],
            :baseurl        => "http://foo.example.com/osg/3.1/el6/#{h[:path]}/x86_64",
            :mirrorlist     => 'absent',
            :descr          => "OSG Software for Enterprise Linux 6#{h[:desc]} - x86_64",
            :enabled        => h[:enabled],
            :failovermethod => 'priority',
            :gpgcheck       => '1',
            :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
            :priority       => '98',
            :require        => 'Gpg_key[osg]',
          })
        end
      end

      [
        {:name => 'osg-upcoming', :path => 'release', :desc => 'Upcoming'},
        {:name => 'osg-upcoming-development', :path => 'development', :desc => 'Upcoming Development'},
        {:name => 'osg-upcoming-testing', :path => 'testing', :desc => 'Upcoming Testing'},
      ].each do |h|
        it do
          should contain_yumrepo(h[:name]).only_with({
            :name           => h[:name],
            :baseurl        => "http://foo.example.com/osg/upcoming/el6/#{h[:path]}/x86_64",
            :mirrorlist     => 'absent',
            :descr          => "OSG Software for Enterprise Linux 6 - #{h[:desc]} - x86_64",
            :enabled        => '0',
            :failovermethod => 'priority',
            :gpgcheck       => '1',
            :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG',
            :priority       => '98',
            :require        => 'Gpg_key[osg]',
          })
        end
      end
    end
  end

  context "when enable_osg_contrib => true" do
    let(:pre_condition) { "class { 'osg': enable_osg_contrib => true }" }

    it { should contain_yumrepo('osg-contrib').with_enabled('1') }
  end
end