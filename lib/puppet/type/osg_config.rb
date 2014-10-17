Puppet::Type.newtype(:osg_config) do

  @@file_path = ''

  ensurable

  newparam(:name, :namevar => true) do
    desc "Section/setting name to manage from /etc/osg/config.d"
    # namevar should be of the form section/setting
    validate do |value|
      unless value =~ /\S+\/\S+/
        fail("Invalid osg_config #{value}, entries should be in the form of section/setting.")
      end
    end
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |v|
      v.to_s.strip
    end
  end

  validate do
    if self[:ensure] == :present
      if self[:value].nil?
        raise Puppet::Error, "Property value must be set for #{self[:name]} when ensure is present"
      end
    end
  end
end
