require 'spec_helper_system'

describe 'osg_version tests:' do
  it 'should be empty' do
    facter(:puppet => true) do |r|
      r.facts['osg_version'].should nil
      r.stderr.should be_empty
      r.exit_code.should be_zero
    end
  end
end
