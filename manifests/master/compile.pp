# profile to apply to Puppet Enterprise masters not acting as a CA
# Alex Harden (aharden@te.com)
# PE 3.7: https://docs.puppetlabs.com/pe/latest/install_multimaster.html
class te_puppet::master::compile (
  $license_end_date,
  $license_nodes,
  ) {
  include ::te_puppet::master

  File {
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
  }

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

  # backup of CA server files
  file { "${::settings::confdir}/ssl/ca":
    ensure => directory,
  }

  file { "${::settings::confdir}/ssl/ca/ca_crl.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/ca/ca_crl.pem",
  }

  file { "${::settings::ssldir}/certs/ca.pem":
    source => "puppet://${::settings::ca_server}/puppet_ssl/certs/ca.pem",
  }
}
