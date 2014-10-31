class profiles::puppet::master::compile {
  include ::profiles::puppet::master

  ini_setting { 'ca_false':
    ensure  => present,
    path    => $::settings::config,
    section => 'main',
    setting => 'ca',
    value   => false,
  }

  File {
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
  }

  file { "${::settings::confdir}/ssl/ca":
    ensure => directory,
  }

  file { "${::settings::confdir}/ssl/ca/ca_crl.pem":
    ensure => file,
    source => 'puppet:///puppet_ssl/ca/ca_crl.pem',
    notify => Service['pe-httpd'],
  }

  file { "${::settings::ssldir}/public_keys/pe-internal-mcollective-servers.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/public_keys/pe-internal-mcollective-servers.pem",
  }

  file { "${::settings::ssldir}/public_keys/pe-internal-peadmin-mcollective-client.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/public_keys/pe-internal-peadmin-mcollective-client.pem",
  }

  file { "${::settings::ssldir}/public_keys/pe-internal-puppet-console-mcollective-client.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem",
  }

  file { "${::settings::ssldir}/private_keys/pe-internal-mcollective-servers.pem":
    mode   => '0640',
    source => "puppet://${::settings::ca_server}/puppet_ssl/private_keys/pe-internal-mcollective-servers.pem",
  }

  file { "${::settings::ssldir}/certs/pe-internal-mcollective-servers.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/certs/pe-internal-mcollective-servers.pem",
  }

  file { "${::settings::ssldir}/certs/ca.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/certs/ca.pem",
  }
}
