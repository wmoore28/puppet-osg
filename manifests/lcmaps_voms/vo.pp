#
define osg::lcmaps_voms::vo (
  Variant[Array, String] $dn,
  String $user = $name,
  Integer $order = 50,
) {

  concat::fragment { "osg::lcmaps_voms::vo-${name}":
    target  => '/etc/grid-security/voms-mapfile',
    content => template('osg/lcmaps_voms/mapfile.erb'),
    order   => $order,
  }

}
