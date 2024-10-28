# network::interfaces
class network::interfaces (
  Hash $interfaces,
) {

  $interfaces.each |String $interface_name, Hash $config| {

    # Define variables for each interface configuration
    $ip_address  = $config['ip_address']
    $gateway     = $config['gateway']
    $dns_servers = $config['dns_servers']

    # Define the path to the .nmconnection configuration file
    $config_path = "/etc/NetworkManager/system-connections/${interface_name}.nmconnection"

    # Use a template to manage the content of the .nmconnection file
    file { $config_path:
      ensure  => file,
      content => template('network/nmconnection.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      notify  => Exec["reload_${interface_name}"],
    }

    # Reload and bring up the network interface using NetworkManager
    exec { "reload_${interface_name}":
      command     => "/usr/bin/nmcli connection reload && /usr/bin/nmcli connection up ${interface_name}",
      path        => ['/usr/bin', '/usr/sbin'],
      refreshonly => true,
    }
  }
}

