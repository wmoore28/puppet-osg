require 'spec_helper_acceptance'

describe 'osg::rsv class:' do
  context "when default parameters" do
    node = only_host_with_role(hosts, 'rsv')

    it 'should run successfully' do
      pp =<<-EOS
        class { 'osg':
          auth_type => 'lcmaps_voms',
        }
        class { 'osg::rsv':
          manage_firewall => false,
          rsvcert_source => 'file:///tmp/rsvcert.pem',
          rsvkey_source  => 'file:///tmp/rsvkey.pem',
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like "osg::rsv", node

  end
end
