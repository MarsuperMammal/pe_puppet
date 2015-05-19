# a class for servers with the Puppet Enterprise master role installed
# don't apply directly to roles:
#   use te_puppet::master::ca or te_puppet::master::compile profiles
class pe_puppet::master {
  include ::limits
  include ::r10k
  include ::r10k::mcollective
  include ::r10k::webhook
  include ::r10k::webhook::config
  Class['::r10k::webhook::config'] -> Class['::r10k::webhook']

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  Ini_setting {
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
  }

  case $::osfamily {
    'Debian': {
      package { 'daemon': # required by r10k webhook
        ensure => 'latest',
      }
    }
    default: {}
  }

  ini_setting { 'puppet base module path':
    setting => 'basemodulepath',
    value   => '/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules',
  }

  ini_setting { 'puppet environment path':
    setting => 'environmentpath',
    value   => '/etc/puppetlabs/puppet/environments',
  }

  file { $settings::hiera_config:
    ensure => file,
    source => "puppet:///modules/${module_name}/hiera.yaml",
    notify => Service['pe-puppetserver'],
  }
}
