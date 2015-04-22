# a class for servers with the Puppet Enterprise master role installed
# Alex Harden (aharden@te.com)
# don't apply directly to roles:
#   use te_puppet::master::ca or te_puppet::master::compile profiles
class te_puppet::master (
  $proxy_port,
  $proxy_url,
  $r10k_frequency = undef,
) inherits te_puppet {
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

  # /root/.curlrc w/proxy fixes pe_repo download issues
  file { '/root/.curlrc':
    ensure  => file,
    content => template("${module_name}/curlrc.erb"),
  }

  if $r10k_frequency {
    cron { 'r10k deploy runs':
      ensure  => present,
      command => '. /root/.bashrc; /usr/bin/r10k deploy environment -pv',
      user    => 'root',
      minute  => "*/${r10k_frequency}",
    }
  }
}
