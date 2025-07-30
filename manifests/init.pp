# @summary Class for common OSG parameters and common resources
#
# @param manage_repos
#   Install/configure OSG repos
# @param osg_release
#   OSG release
# @param manage_epel
#   Manage the EPEL repo
# @param auth_type
#   Grid authentication type
# @param cacerts_package_name
#   Package name for osg-ca-certs
# @param cacerts_package_ensure
#   CA certs package ensure
# @param shared_certs_path
#   Path to location of shared certs, for example if storing certs on NFS
# @param globus_tcp_port_range_min
#   Min for GLOBUS_TCP_PORT_RANGE
# @param globus_tcp_port_range_max
#   Max for GLOBUS_TCP_PORT_RANGE
# @param globus_tcp_source_range_min
#   Min for GLOBUS_TCP_SOURCE_RANGE
# @param globus_tcp_source_range_max
#   Max for GLOBUS_TCP_SOURCE_RANGE
# @param enable_exported_resources
#   Enable exported resources, useful when services like Squid and CE live on different hosts
# @param exported_resources_export_tag
#   Exported resources export tag
# @param exported_resource_collect_tag
#   Exported resources collect tag
# @param site_info_group
#   osg-configure Site Information/group
# @param site_info_host_name
#   osg-configure Site Information/host_name
# @param site_info_resource
#   osg-configure Site Information/resource
# @param site_info_resource_group
#   osg-configure Site Information/resource_group
# @param site_info_sponsor
#   osg-configure Site Information/sponsor
# @param site_info_site_policy
#   osg-configure Site Information/site_policy
# @param site_info_contact
#   osg-configure Site Information/contact
# @param site_info_email
#   osg-configure Site Information/email
# @param site_info_city
#   osg-configure Site Information/city
# @param site_info_country
#   osg-configure Site Information/country
# @param site_info_longitude
#   osg-configure Site Information/longitude
# @param site_info_latitude
#   osg-configure Site Information/latitude
# @param squid_location
#   osg-confgiure Squid/location
# @param purge_local_site_settings
#   Purge unmanaged osg_local_site_settings resources
# @param purge_gip_config
#   Purge unmanaged osg_gip_config
#
class osg (
  Boolean $manage_repos = true,
  Enum['23','24'] $osg_release = '3.6',
  Boolean $manage_epel = true,
  Enum['lcmaps_voms'] $auth_type = 'lcmaps_voms',
  Enum['osg-ca-certs', 'igtf-ca-certs', 'empty-ca-certs'] $cacerts_package_name = 'osg-ca-certs',
  String $cacerts_package_ensure = 'installed',
  String $shared_certs_path = '/opt/grid-certificates',
  Integer[0, 65535] $globus_tcp_port_range_min = 40000,
  Integer[0, 65535] $globus_tcp_port_range_max = 41999,
  Integer[0, 65535] $globus_tcp_source_range_min = 40000,
  Integer[0, 65535] $globus_tcp_source_range_max = 41999,
  Boolean $enable_exported_resources = false,
  String $exported_resources_export_tag = $facts['networking']['domain'],
  String $exported_resource_collect_tag = $facts['networking']['domain'],
  # INI config values
  String $site_info_group = 'OSG',
  String $site_info_host_name = $facts['networking']['fqdn'],
  String $site_info_resource = 'UNAVAILABLE',
  String $site_info_resource_group = 'UNAVAILABLE',
  String $site_info_sponsor = 'UNAVAILABLE',
  String $site_info_site_policy = 'UNAVAILABLE',
  String $site_info_contact = 'UNAVAILABLE',
  String $site_info_email = 'UNAVAILABLE',
  String $site_info_city = 'UNAVAILABLE',
  String $site_info_country = 'UNAVAILABLE',
  String $site_info_longitude = 'UNAVAILABLE',
  String $site_info_latitude = 'UNAVAILABLE',
  Optional[String] $squid_location = undef,
  Boolean $purge_local_site_settings = true,
  Boolean $purge_gip_config = true,
) {

  $osfamily = $facts.dig('os', 'family')
  $osmajor = $facts.dig('os', 'release', 'major')
  $supported = ['RedHat-7','RedHat-8', 'RedHat-9']
  $os = "${osfamily}-${osmajor}"
  if ! ($os in $supported) {
    fail("Unsupported OS: ${osfamily}, module ${module_name} only supports RedHat 7,8,9")
  }

  if $manage_epel {
    contain ::epel
  }
  if $manage_repos {
    contain osg::repos
  }

  include osg::configure

  # Avoid collecting resources intended for export
  Osg_local_site_settings<| tag != $exported_resources_export_tag |> ~> Exec['osg-configure']
  Osg_gip_config <| |> ~> Exec['osg-configure']

  resources { 'osg_local_site_settings':
    purge  => $purge_local_site_settings,
    notify => Exec['osg-configure'],
  }

  resources { 'osg_gip_config':
    purge  => $purge_gip_config,
    notify => Exec['osg-configure'],
  }

}
