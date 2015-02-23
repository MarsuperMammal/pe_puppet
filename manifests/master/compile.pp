# profile to apply to Puppet Enterprise masters not acting as a CA
# Alex Harden (aharden@te.com)
# PE 3.7: https://docs.puppetlabs.com/pe/latest/install_multimaster.html
class te_puppet::master::compile (
  $license_end_date,
  $license_nodes,
  ) {
  include ::te_puppet::master

  # PE license file
  file { '/etc/puppetlabs/license.key':
    ensure  => 'file',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/license.key.erb"),
  }

  # don't serve as a Puppet CA
  ini_setting { 'ca_false':
    ensure  => present,
    path    => $::settings::config,
    section => 'main',
    setting => 'ca',
    value   => false,
  }

  case $::pe_version {
    '3.3.2': {

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
  default: {}
  }
}
