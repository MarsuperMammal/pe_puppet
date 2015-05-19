# profile to apply to Puppet Enterprise masters not acting as a CA
# PE 3.7: https://docs.puppetlabs.com/pe/latest/install_multimaster.html
class pe_puppet::master::compile {

  File {
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
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
