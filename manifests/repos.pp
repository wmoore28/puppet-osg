# @summary Manage OSG repos
# @api private
class osg::repos {

  include osg

  package { 'osg-release':
    ensure   => 'installed',
    source   => "https://repo.osg-htc.org/osg/${osg::osg_release}-main/osg-${osg::osg_release}-main-el${facts['os']['release']['major']}-release-latest.rpm",
    provider => 'rpm',
  }

}
