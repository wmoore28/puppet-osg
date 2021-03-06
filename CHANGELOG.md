# Change Log

## [4.3.1](https://github.com/treydock/puppet-osg/tree/4.3.1) (2019-11-12)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.3.0...4.3.1)

**Fixed bugs:**

- Re-release 4.3.0 [\#27](https://github.com/treydock/puppet-osg/pull/27) ([treydock](https://github.com/treydock))

## [4.3.0](https://github.com/treydock/puppet-osg/tree/4.3.0) (2019-11-11)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.2.2...4.3.0)

**Implemented enhancements:**

- Support Puppet 5 & 6 and bump module dependencies [\#25](https://github.com/treydock/puppet-osg/pull/25) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Add work around for OSG-SEC-2019-11-11 [\#26](https://github.com/treydock/puppet-osg/pull/26) ([treydock](https://github.com/treydock))
- Remove old autofs parameter mapfile\_manage [\#24](https://github.com/treydock/puppet-osg/pull/24) ([wmoore28](https://github.com/wmoore28))

## [4.2.2](https://github.com/treydock/puppet-osg/tree/4.2.2) (2018-07-05)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.2.1...4.2.2)

**Fixed bugs:**

- Update rsv apache template to match upstream [\#23](https://github.com/treydock/puppet-osg/pull/23) ([treydock](https://github.com/treydock))

## [4.2.1](https://github.com/treydock/puppet-osg/tree/4.2.1) (2018-05-02)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.2.0...4.2.1)

**Fixed bugs:**

- Fix permissions for /bin/fusermount on EL6 [\#22](https://github.com/treydock/puppet-osg/pull/22) ([treydock](https://github.com/treydock))

## [4.2.0](https://github.com/treydock/puppet-osg/tree/4.2.0) (2018-04-24)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.1.1...4.2.0)

**Implemented enhancements:**

- Make repo URLs match what is defined in latest osg-release RPMs [\#20](https://github.com/treydock/puppet-osg/pull/20) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Limit osg-empty repo to packages installed [\#21](https://github.com/treydock/puppet-osg/pull/21) ([treydock](https://github.com/treydock))

## [4.1.1](https://github.com/treydock/puppet-osg/tree/4.1.1) (2018-01-09)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.1.0...4.1.1)

**Fixed bugs:**

- Allow autofs 4.x, apache 2.x and concat 4.x dependencies [\#19](https://github.com/treydock/puppet-osg/pull/19) ([treydock](https://github.com/treydock))

## [4.1.0](https://github.com/treydock/puppet-osg/tree/4.1.0) (2017-11-09)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/4.0.0...4.1.0)

**Implemented enhancements:**

- Set RSV cert and key path for osg-configure and ensure the files exist before the values are set [\#17](https://github.com/treydock/puppet-osg/pull/17) ([treydock](https://github.com/treydock))
- Fully drop support for Puppet 3 [\#16](https://github.com/treydock/puppet-osg/pull/16) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Fix rsv service resource to check status instead of presence of file [\#18](https://github.com/treydock/puppet-osg/pull/18) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- Use release\_checks rake task for travis-ci tests [\#15](https://github.com/treydock/puppet-osg/pull/15) ([treydock](https://github.com/treydock))
- Remove unused variables [\#14](https://github.com/treydock/puppet-osg/pull/14) ([treydock](https://github.com/treydock))
- Remove sudo and logrotate dependencies, these modules are not used by this module [\#13](https://github.com/treydock/puppet-osg/pull/13) ([treydock](https://github.com/treydock))

## [4.0.0](https://github.com/treydock/puppet-osg/tree/4.0.0) (2017-10-02)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/3.0.0...4.0.0)

**Merged pull requests:**

- Remove support for OSG 3.3 components [\#12](https://github.com/treydock/puppet-osg/pull/12) ([treydock](https://github.com/treydock))
- Move storage INI configurations to osg::ce [\#11](https://github.com/treydock/puppet-osg/pull/11) ([treydock](https://github.com/treydock))

## [3.0.0](https://github.com/treydock/puppet-osg/tree/3.0.0) (2017-10-02)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/2.0.0...3.0.0)

**Implemented enhancements:**

- Switch all parameters to use proper data types [\#9](https://github.com/treydock/puppet-osg/pull/9) ([treydock](https://github.com/treydock))
- Set defaults for osg::osg\_release to 3.4 and osg::auth\_type to lcmaps\_voms [\#3](https://github.com/treydock/puppet-osg/pull/3) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Only manage osg::ce http cert/key on OSG 3.3 [\#8](https://github.com/treydock/puppet-osg/pull/8) ([treydock](https://github.com/treydock))
- Do not manage tomcat user/group for OSG 3.4 for osg::ce [\#7](https://github.com/treydock/puppet-osg/pull/7) ([treydock](https://github.com/treydock))
- Do not install empty-torque, no longer needed. [\#2](https://github.com/treydock/puppet-osg/pull/2) ([treydock](https://github.com/treydock))

**Merged pull requests:**

- Remove GRAM resources and only support HTCondor-CE gateway [\#10](https://github.com/treydock/puppet-osg/pull/10) ([treydock](https://github.com/treydock))
- Puppet syntax cleanup [\#6](https://github.com/treydock/puppet-osg/pull/6) ([treydock](https://github.com/treydock))
- Remove deprecated osg::lcmaps class [\#5](https://github.com/treydock/puppet-osg/pull/5) ([treydock](https://github.com/treydock))
- Add notify to resources that purge configs [\#4](https://github.com/treydock/puppet-osg/pull/4) ([treydock](https://github.com/treydock))

## [2.0.0](https://github.com/treydock/puppet-osg/tree/2.0.0) (2017-09-25)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/1.0.0...2.0.0)

Last release before only supporting OSG 3.4

Require Puppet >= 4 or Puppet 3 with future parser

**Breaking changes**

* Change supported OSG releases to be 3.3 and 3.4
* Rename several parameters for osg::bestman
    * securePort -> secure_port
    * localPathListToBlock -> local\_path\_list\_to_block
    * localPathListAllowed -> local\_path\_list_allowed
    * supportedProtocolList -> supported\_protocol_list
    * noSudoOnLs -> no\_sudo\_on_ls
    * accessFileSysViaGsiftp -> access\_file\_sys\_via_gsiftp
* Changes to osg::ce class
    * Set gram\_gateway_enabled to false by default
    * Remove batch\_system\_package_name parameter
    * Remove ce\_package_name parameter
    * Remove use_slurm parameter
* Rename osg::cvmfs server_urls to cern\_server_urls and make default empty, removes /etc/cvmfs/domain.d/cern.ch.local by default
* Add dependency on puppet/autofs module
* Add dependency on yo61/logrotate
* Rework gums resources

**Features**

* Move fetch-crl resources to dedicated osg::fetch_crl class
* osg::cacerts now contains osg::fetch_crl if cacerts package is not set to empty-ca-certs
* Support LCMAPS VOMS by setting `auth_type` to `lcmaps_voms`
* Rework how batch system is configured in osg::ce, better support for Torque and retain support for SLURM
* Allow management of custom htcondor-ce config, 99-local.conf
* Allow management of blahp local submit file
* Allow management of htcondor-ce-view
* osg::ce will set EnableProbe=1 for the appropriate batch system gratia probe
* Add more configuration parameters to osg::squid
* Add osg::utils class
* No longer silently skip running osg-configure if errors are present

## [1.0.0](https://github.com/treydock/puppet-osg/tree/1.0.0) (2017-05-04)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/v0.0.3...1.0.0)

## [v0.0.3](https://github.com/treydock/puppet-osg/tree/v0.0.3) (2013-06-14)
[Full Changelog](https://github.com/treydock/puppet-osg/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/treydock/puppet-osg/tree/v0.0.2) (2013-06-11)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*