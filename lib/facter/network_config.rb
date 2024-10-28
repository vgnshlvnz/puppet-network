Facter.add(:network_config) do
  confine kernel: 'Linux'
  confine os: { family: 'RedHat', release: { major: '9' } }

  setcode do
    network_configurations = {}
    config_files = Dir.glob('/etc/NetworkManager/system-connections/*.nmconnection')

    config_files.each do |file|
      interface_name = File.basename(file, '.nmconnection')
      network_configurations[interface_name] = File.read(file)
    end

    network_configurations.empty? ? 'No network configurations found' : network_configurations
  end
end
