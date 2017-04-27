require 'spec_helper_acceptance'

describe 'osg::ce class:' do
  context "when default parameters" do
    node = only_host_with_role(hosts, 'ce')

    it 'should run successfully' do
      pp =<<-EOS
        class { 'osg': }
        class { 'osg::cacerts::updater': }
        class { 'osg::ce':
          manage_firewall => false,
          hostcert_source => 'file:///tmp/hostcert.pem',
          hostkey_source  => 'file:///tmp/hostkey.pem',
          httpcert_source => 'file:///tmp/httpcert.pem',
          httpkey_source  => 'file:///tmp/httpkey.pem',
        }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like "osg::cacerts", node
    it_behaves_like "osg::cacerts::updater", node

  end
end
