# Class: osg::wn: See README.md for documentation.
class osg::wn inherits osg::params {

  include osg
  include osg::cacerts

  $xrootd_client_package_name = 'xrootd-client'

  package { 'osg-wn-client':
    ensure  => 'present',
  }

  package { 'xrootd-client':
    ensure => 'present',
    name   => $xrootd_client_package_name,
  }

  anchor { 'osg::wn::start': }
  -> Class['osg']
  -> Class['osg::cacerts']
  -> Package['osg-wn-client']
  -> Package['xrootd-client']
  -> anchor { 'osg::wn::end': }

}
