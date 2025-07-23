# @summary Manage OSG repos
# @api private
class osg::repos {

  include osg

  if $osg::repo_use_mirrors {
    $baseurls   = {
      'osg'                       => 'absent',
      'osg-empty'                 => 'absent',
      'osg-contrib'               => 'absent',
      'osg-development'           => 'absent',
      'osg-testing'               => 'absent',
      'osg-upcoming'              => 'absent',
      'osg-upcoming-development'  => 'absent',
      'osg-upcoming-testing'      => 'absent',
    }

    $mirrorlists = {
      'osg'                       => "https://repo.opensciencegrid.org/mirror/osg/${osg::osg_release}/el${facts['os']['release']['major']}/release/${facts['os']['architecture']}",
      'osg-empty'                 => "https://repo.opensciencegrid.org/mirror/osg/${osg::osg_release}/el${facts['os']['release']['major']}/empty/${facts['os']['architecture']}",
      'osg-contrib'               => "https://repo.opensciencegrid.org/mirror/osg/${osg::osg_release}/el${facts['os']['release']['major']}/contrib/${facts['os']['architecture']}",
      'osg-development'           => "https://repo.opensciencegrid.org/mirror/osg/${osg::osg_release}/el${facts['os']['release']['major']}/development/${facts['os']['architecture']}",
      'osg-testing'               => "https://repo.opensciencegrid.org/mirror/osg/${osg::osg_release}/el${facts['os']['release']['major']}/testing/${facts['os']['architecture']}",
      'osg-upcoming'              => "https://repo.opensciencegrid.org/mirror/osg/upcoming/el${facts['os']['release']['major']}/release/${facts['os']['architecture']}",
      'osg-upcoming-development'  => "https://repo.opensciencegrid.org/mirror/osg/upcoming/el${facts['os']['release']['major']}/development/${facts['os']['architecture']}",
      'osg-upcoming-testing'      => "https://repo.opensciencegrid.org/mirror/osg/upcoming/el${facts['os']['release']['major']}/testing/${facts['os']['architecture']}",
    }
  } else {
    $baseurls   = {
      'osg'                       => "${osg::repo_baseurl_bit}/osg/${osg::osg_release}/el${facts['os']['release']['major']}/release/${facts['os']['architecture']}",
      'osg-empty'                 => "${osg::repo_baseurl_bit}/osg/${osg::osg_release}/el${facts['os']['release']['major']}/empty/${facts['os']['architecture']}",
      'osg-contrib'               => "${osg::repo_baseurl_bit}/osg/${osg::osg_release}/el${facts['os']['release']['major']}/contrib/${facts['os']['architecture']}",
      'osg-development'           => "${osg::repo_development_baseurl_bit_real}/osg/${osg::osg_release}/el${facts['os']['release']['major']}/development/${facts['os']['architecture']}",
      'osg-testing'               => "${osg::repo_testing_baseurl_bit_real}/osg/${osg::osg_release}/el${facts['os']['release']['major']}/testing/${facts['os']['architecture']}",
      'osg-upcoming'              => "${osg::repo_upcoming_baseurl_bit_real}/osg/upcoming/el${facts['os']['release']['major']}/release/${facts['os']['architecture']}",
      'osg-upcoming-development'  => "${osg::repo_upcoming_baseurl_bit_real}/osg/upcoming/el${facts['os']['release']['major']}/development/${facts['os']['architecture']}",
      'osg-upcoming-testing'      => "${osg::repo_upcoming_baseurl_bit_real}/osg/upcoming/el${facts['os']['release']['major']}/testing/${facts['os']['architecture']}",
    }

    $mirrorlists = {
      'osg'                       => 'absent',
      'osg-empty'                 => 'absent',
      'osg-contrib'               => 'absent',
      'osg-development'           => 'absent',
      'osg-testing'               => 'absent',
      'osg-upcoming'              => 'absent',
      'osg-upcoming-development'  => 'absent',
      'osg-upcoming-testing'      => 'absent',
    }
  }

  if $facts['os']['release']['major'] < '8' {
    ensure_packages(['yum-plugin-priorities'])
  }

  Yumrepo {
    gpgcheck        => '1',
    gpgkey          => $osg::_repo_gpgkey,
    priority        => '98',
  }

  yumrepo { 'osg':
    baseurl    => $baseurls['osg'],
    mirrorlist => $mirrorlists['osg'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - ${facts['os']['architecture']}",
    enabled    => bool2num($osg::enable_osg),
  }

  yumrepo { 'osg-empty':
    baseurl     => $baseurls['osg-empty'],
    mirrorlist  => $mirrorlists['osg-empty'],
    descr       => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Empty Packages - ${facts['os']['architecture']}",
    enabled     => bool2num($osg::enable_osg_empty),
    includepkgs => 'empty-ca-certs empty-slurm empty-torque',
  }

  yumrepo { 'osg-contrib':
    baseurl    => $baseurls['osg-contrib'],
    mirrorlist => $mirrorlists['osg-contrib'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Contributed - ${facts['os']['architecture']}",
    enabled    => bool2num($osg::enable_osg_contrib),
  }

  yumrepo { 'osg-development':
    baseurl    => $baseurls['osg-development'],
    mirrorlist => $mirrorlists['osg-development'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Development - ${facts['os']['architecture']}",
    enabled    => '0',
  }

  yumrepo { 'osg-testing':
    baseurl    => $baseurls['osg-testing'],
    mirrorlist => $mirrorlists['osg-testing'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Testing - ${facts['os']['architecture']}",
    enabled    => '0',
  }

  yumrepo { 'osg-upcoming':
    baseurl    => $baseurls['osg-upcoming'],
    mirrorlist => $mirrorlists['osg-upcoming'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Upcoming - ${facts['os']['architecture']}",
    enabled    => bool2num($osg::enable_osg_upcoming),
  }

  yumrepo { 'osg-upcoming-development':
    baseurl    => $baseurls['osg-upcoming-development'],
    mirrorlist => $mirrorlists['osg-upcoming-development'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Upcoming Development - ${facts['os']['architecture']}",
    enabled    => '0',
  }

  yumrepo { 'osg-upcoming-testing':
    baseurl    => $baseurls['osg-upcoming-testing'],
    mirrorlist => $mirrorlists['osg-upcoming-testing'],
    descr      => "OSG Software for Enterprise Linux ${facts['os']['release']['major']} - Upcoming Testing - ${facts['os']['architecture']}",
    enabled    => '0',
  }

}
