# Class: osg::squid: See README.md for documentation.
class osg::squid (
  $customize_template         = 'osg/squid/customize.sh.erb',
  $net_local                  = '10.0.0.0/8 172.16.0.0/12 192.168.0.0/16',
  $manage_firewall            = true,
  $squid_firewall_ensure      = 'present',
  $monitoring_firewall_ensure = 'present',
  $private_interface          = undef,
  $public_interface           = undef,
) inherits osg::params {

  validate_bool($manage_firewall)

  include osg

  if $manage_firewall {
    firewall { '100 allow squid access':
      ensure  => $squid_firewall_ensure,
      port    => '3128',
      proto   => 'tcp',
      iniface => $private_interface,
      action  => 'accept',
    }

    firewall { '100 allow squid monitoring':
      ensure  => $monitoring_firewall_ensure,
      port    => '3401',
      proto   => 'udp',
      source  => '128.142.0.0/16',
      iniface => $public_interface,
      action  => 'accept',
    }

    firewall { '101 allow squid monitoring':
      ensure  => $monitoring_firewall_ensure,
      port    => '3401',
      proto   => 'udp',
      source  => '188.185.0.0/17',
      iniface => $public_interface,
      action  => 'accept',
    }
  }

  package { 'frontier-squid':
    ensure  => 'present',
    require => Yumrepo['osg'],
    before  => File['/etc/squid/customize.sh'],
  }

  file { '/etc/squid/customize.sh':
    ensure  => 'file',
    owner   => 'squid',
    group   => 'squid',
    mode    => '0755',
    content => template($customize_template),
  }

  service { 'frontier-squid':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File['/etc/squid/customize.sh'],
  }

  if $osg::enable_exported_resources {
    @@osg_local_site_settings { 'Squid/enabled':
      value => true,
      tag   => $osg::exported_resources_export_tag,
    }

    $_squid_location = pick($osg::squid_location, $::fqdn)
    @@osg_local_site_settings { 'Squid/location':
      value => $_squid_location,
      tag   => $osg::exported_resources_export_tag,
    }
  }

}
