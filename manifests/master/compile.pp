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
}
