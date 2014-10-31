# a class for servers with the Puppet Enterprise master role installed (aharden@te.com)
# don't apply directly to roles: use te_puppet::master::ca or te_puppet::master::compile profiles
class te_puppet::master (
  $r10k_frequency,
) {
  include ::te_puppet::common
  include ::r10k
  include ::r10k::mcollective
  include ::r10k::webhook
  include ::r10k::webhook::config
  Class['::r10k::webhook::config'] -> Class['::r10k::webhook']
  Ini_setting {
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
  }
  ini_setting { 'puppet base module path':
    setting => 'basemodulepath',
    value   => '/opt/puppet/share/puppet/modules',
  }
  ini_setting { 'puppet environment path':
    setting => 'environmentpath',
    value   => '/etc/puppetlabs/puppet/environments',
  }
  file { $settings::hiera_config:
    ensure => file,
    source => "puppet:///modules/${module_name}/hiera.yaml",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['pe-httpd'],
  }
  file { 'Symlink to puppet bin for r10k use':
    ensure => link,
    target => '/opt/puppet/bin/puppet',
    path   => '/usr/bin/puppet',
  }
  cron { 'r10k deploy runs':
    ensure  => present,
    command => '. /root/.bashrc; /usr/bin/r10k deploy environment -pv',
    user    => 'root',
    minute  => "*/${r10k_frequency}",
  }
}
