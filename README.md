# puppet-osg

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/osg.svg)](https://forge.puppetlabs.com/treydock/osg)
[![Build Status](https://travis-ci.org/treydock/puppet-osg.svg?branch=master)](https://travis-ci.org/treydock/puppet-osg)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration examples and options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for testing and contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

The OSG module manages the various components that make up the Open Science Grid software stack.

## OSG Compatibility

The current version support matrix is as follows:

OSG Versions       |  3.3 |  3.4 |
:------------------|:----:|:----:|
**puppet-osg 1.x** | yes  | no   |
**puppet-osg 2.x** | yes  | yes  |
**puppet-osg 3.x** | yes  | yes  |
**puppet-osg 4.x** | no   | yes  |

## Usage

### Classes

The public classes of this module are split into "roles".  For example a CE would use the class `osg::ce`.

#### osg

The OSG class is required by all the other classes.  This class sets parameters that are used by multiple "roles" and is the class responsible for configuring the OSG repos.

    class { 'osg': }

If all systems pull their grid-certificates from a shared filesystem then you instruct this module to install the `empty-ca-certs` package and symlink `/home/osg/grid-certificates` to `/etc/grid-security/certificates`.  If this method is used some script must be executed on a regular basis to sync one system's certificates into the shared location.  Such a script is currently outside the scope of this module.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }

The `cacerts_package_ensure` and `cacerts_other_packages_ensure` parameters can be used to ensure the latest CA certs package is installed.  This is basically the same functionality as provided by the resources managed under the `osg::cacerts::updater` class.

    class { 'osg':
      cacerts_package_name          => 'osg-ca-certs',
      cacerts_package_ensure        => 'latest',
      cacerts_other_packages_ensure => 'latest',
    }

#### osg::cacerts::updater

The `osg::cacerts::updater` class by default will perform the following actions

* Install `osg-ca-certs-updater` and `fetch-crl` packages
* Configure `/etc/cron.d/osg-ca-certs-updater`
* Start the `osg-ca-certs-updater-cron` service
* Start the `fetch-crl-cron` service
* Stop the `fetch-crl-boot` service

Example usage:

    class { 'osg':
      cacerts_package_name => 'osg-ca-certs',
    }
    class { 'osg::cacerts::updater': }

This class essentially performs the same role as setting `osg::cacerts_package_ensure` and `osg::cacerts_other_packages_ensure` to `latest`.

#### osg::ce

This class by default configures a GRAM CE.  The following example is to configure using HTCondor-CE that uses the SLURM batch system.  This example also shows how to setup a host as the system that keeps the shared grid-certificates up-to-date.


    class { 'osg':
      cacerts_package_name  => 'osg-ca-certs',
    }
    class { 'osg::cacerts::updater': }
    class { 'osg::ce':
      batch_system              => 'slurm',
      hostcert_source           => 'file:///home/admin/osg/certs/ce/hostcert.pem',
      hostkey_source            => 'file:///home/admin/osg/certs/ce/hostkey.pem',
    }


#### osg::client

The `osg::client` class is intended to configure client systems, such as login nodes, to interact with the OSG software.  The example below is a rough idea of how one would configure a client system to send both condor and condor-ce requests to a remote HTCondor-CE instance.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::client'
      condor_configs_override     => {
        'SCHEDD_HOST'     => 'ce.example.tld',
        'COLLECTOR_HOST'  => 'ce.example.tld:9619',
      }
      condor_ce_configs_override  => {
        'SCHEDD_HOST'     => 'ce.example.tld',
        'COLLECTOR_HOST'  => 'ce.example.tld:9619',
      }
    }

The default behavior is to ensure both condor and htcondor-ce are installed but the services for each are disabled.

#### osg::cvmfs

The `osg::cvmfs` class will install and configure a system to access the CVMFS wide-area filesystem.  The default parameter values should be enough to allow access to the filesystem.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::cvmfs': }

Any host that needs to access /cvmfs should have this class assigned.

#### osg::gridftp

The `osg::gridftp` class by default will configure a system as a standalone OSG GridFTP server.  Note that the `osg::ce` classes declares this class with `standalone` set to `false`, so do not include this class if the `osg::ce` class is assigned.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::gridftp':
      hostcert_source       => 'file:///home/admin/osg/certs/gridftp/hostcert.pem',
      hostkey_source        => 'file:///home/admin/osg/certs/gridftp/hostkey.pem',
    }

#### osg::lcmaps_voms

The following example will setup LCMAPS VOMS to authenticate the GLOW VO and ban CMS production.  The `vo` parameter will create `osg::lcmaps_voms::vo` resources and the `users` parameter will create `osg::lcmaps_voms::user` resources.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::lcmaps_voms':
      ban_voms => ['/cms/Role=production/*'],
      ban_users => ['/foo/baz'],
      vos       => {
        'glow' => '/GLOW/*',
        'glow1 => '['/GLOW/chtc/*', '/GLOW/Role=htpc/*'],
      },
      users     => {
        'foo'   => '/fooDN',
        'foobar => ['/foo', '/bar'],
      }
    }

#### osg::lcmaps_voms::vo

This defined type populates `/etc/grid-security/voms-mapfile`.  The `dn` value can be an Array or a String.

    osg::lcmaps_voms::vo { 'nova':
      dn => '/fermilab/nova/Role=pilot',
    }

#### osg::lcmaps_voms::user

This defined type populates `/etc/grid-security/grid-mapfile`.  The `dn` value can be an Array or a String.

    osg::lcmaps_voms::user { 'rsv':
      dn => '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=rsv/ce.example.com',
    }

#### osg::rsv

Example of configuring RSV.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::rsv':
      rsvcert_source    => 'file:///home/admin/osg/certs/rsv/rsvcert.pem',
      rsvkey_source     => 'file:///home/admin/osg/certs/rsv/rsvkey.pem',
      ce_hosts          => 'ce.example.tld',
      htcondor_ce_hosts => 'ce.example.tld',
      gridftp_hosts     => 'ce.example.tld,gridftp1.example.tld',
      gridftp_dir       => '/data/scratch/rsv',
      srm_hosts         => 'srm.example.tld',
      srm_dir           => '/data/scratch/rsv',
    }

#### osg::squid

The `osg::squid` class will configure a system to run the Frontier Squid service.  The example below installs squid and configures the firewall to allow access to squid on the host's `eth0` private interface and allows squid monitoring on the `eth1` public interface.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::squid':
      private_interface => 'eth0',
      public_interface  => 'eth1',
    }

The `customize_template` can be used to pass a site-specific template used to customize squid.  The template provided by this module is very basic.  The value in the example below will look in the `site_osg` Puppet module under `templates/squid` for the file `customize.sh.erb`.  The value of `customize_template` is passed directly to the Puppet `template` function.

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::squid':
      private_interface   => 'eth0',
      public_interface    => 'eth1',
      customize_template  => 'site_osg/squid/customize.sh.erb',
    }

#### osg::utils

The `osg::utils` class will install utility packages from OSG.

Example:

    class { 'osg::utils':}

#### osg::wn

The `osg::wn` class will configure a worker node to work with the OSG software.   This class currently has no parameters and performs the following actions:

* Ensures the osg class is included (repo)
* Ensures the osg::cacerts class is included
* Installs osg-wn-client package
* Installs xrootd-client

Example:

    class { 'osg':
      shared_certs_path     => '/home/osg/grid-certificates',
      cacerts_package_name  => 'empty-ca-certs',
    }
    class { 'osg::wn': }

### Types

#### osg\_local\_site_settings

The `osg_local_site_settings` custom type will configure values in `/etc/osg/config.d/99-local-site-settings.ini`.  Some of the values are set in this module's classes.  One example of a value not currently managed (though may be in the future):

    osg_local_site_settings { 'Storage/se_available':
      value   => true,
    }

Note that boolean values of `true` and `false` are converted to the Python bool values of `True` and `False`.

#### osg\_gip_config

The `osg_gip_config` custom type will configure values in `/etc/osg/config.d/30-gip.ini`.  Example of setting your batch system to SLURM.

    osg_gip_config { 'GIP/batch':
      value => 'slurm',
    }

You can also remove the settings defined in `30-gip.ini` and use the `osg_local_site_settings` type to define all configs in `/etc/osg/config.d/99-local-site-settings.ini`

    resources { 'osg_gip_config': purge => true }
    osg_local_site_settings { 'GIP/batch':
      value => 'slurm',
    }

This can be useful as the `99-local-site-settings.ini` does not take precedence in GIP like it does with osg-configure  ([ref](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/IniConfigurationOptions#Layout)).

## Reference

### Classes

#### Public classes

* `osg` - Sets global values and configures the OSG repos
* `osg::cacerts` - Installs and configures OSG CA certs
* `osg::cacerts::updater` - Configures the OSG CA certs updater.
* `osg::ce` - Configures a CE.
* `osg::client` - Configures an OSG client.
* `osg::cvmfs` - Configures CVMFS.
* `osg::gridftp` - Configures an OSG GridFTP server.
* `osg::lcmaps_voms` - Manage LCMAPS VOMS
* `osg::rsv` - Configures the RSV service.
* `osg::squid` - Configures an OSG Frontier Squid server.
* `osg::utils` - Install OSG utility packages
* `osg::wn` - Configures an OSG worker node.

#### Private classes

* `osg::configure` - Manages osg-configure
* `osg::params` -  Defines module default values
* `osg::repos` - Configure OSG Yumrepo resources
* `osg::ce::install` - Installs CE packages
* `osg::ce::config` - Configures CE
* `osg::ce::service` - Manages CE services
* `osg::client::install` - Installs client packages
* `osg::client::config` - Configures client
* `osg::client:service` - Manages client services
* `osg::cvmfs::user` - Manages user/groups for CVMFS
* `osg::cvmfs::install` - Installs CVMFS
* `osg::cvmfs::config` - Configures CVMFS
* `osg::cvmfs::service` - Manages CVMFS service
* `osg::gridftp::install` - Installs GridFTP
* `osg::gridftp::config` - Configures GridFTP
* `osg::gridftp::service` - Manages GridFTP service
* `osg::lcmaps_voms::install` - Installs LCMAPS VOMS
* `osg::lcmaps_voms::config` - Configure LCMAPS VOMS
* `osg::rsv::users` - Manages RSV users/groups
* `osg::rsv::install` - Installs RSV
* `osg::rsv::config` - Configures RSV
* `osg::rsv::service` - Manages RSV services

### Parameters

#### osg
TODO

#### osg::cacerts::updater
TODO

#### osg::ce
TODO

#### osg::client
TODO

#### osg::cvmfs
TODO

#### osg::gridftp
TODO

#### osg::lcmaps_voms
TODO

#### osg::rsv
TODO

#### osg::squid
TODO

#### osg::utils
TODO

### Types

#### osg\_gip_config

This type writes values to `/etc/osg/config.d/30-gip.ini`.

##### `name`

The name must be in the format of `SECTION/SETTING`

    [GIP]
    batch = slurm

The above would have the name `GIP/batch`.

##### `value`

The value to assign.
A value of `true` is converted to the string `True`.
A value of `false` is converted to the string `False`.
All other values are converted to a string.

#### osg\_local\_site_settings

This type writes values to `/etc/osg/config.d/99-local-site-settings.ini`.

##### `name`

The name must be in the format of `SECTION/SETTING`

    [Squid]
    location = squid.example.tld

The above would have the name `Squid/location`.

##### `value`

The value to assign.
A value of `true` is converted to the string `True`.
A value of `false` is converted to the string `False`.
All other values are converted to a string.

### Facts

#### `osg_version`

Returns the installed OSG version as found in `/etc/osg-version`.

## Limitations

Tested operating systems:

* CentOS 6
* CentOS 7

This module has only been thoroughly tested using OSG 3.2.

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests.  **NOTE: The acceptance tests spawn numerous virtual machines**

    bundle exec rake beaker

## TODO

## Further Information

* [OSG](http://opensciencegrid.github.io/docs/)
