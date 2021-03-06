require 'spec_helper_acceptance'

describe 'osg::gridftp class:' do
  node = only_host_with_role(hosts, 'gridftp')
  context "when default parameters" do

    it 'should run successfully' do
      pp =<<-EOS
        class { 'osg':
          auth_type => 'lcmaps_voms',
        }
        class { 'osg::gridftp':
          manage_firewall => false,
          hostcert_source => 'file:///tmp/hostcert.pem',
          hostkey_source  => 'file:///tmp/hostkey.pem',
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

  end

  context 'GridFTP cleanup' do
    it 'deletes GridFTP packages to pass non-GridFTP tests' do
      # Cleanup the GridFTP so osg-configure works later
      on node, 'yum remove -y osg-gridftp osg-configure\*'
      on node, 'rm -f /etc/osg/config.d/99-local-site-settings.ini'
    end
  end
end
