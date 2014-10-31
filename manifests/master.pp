class profiles::puppet::master (
  $certlist_file,
  $certlist_frequency,
  $r10k_frequency,
) {
  include ::profiles::puppet::common
  include ::r10k
  include ::r10k::mcollective
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
  cron { 'export certlist to file':
    ensure  => present,
    command => ". /root/.bashrc; /usr/local/bin/puppet cert list --all > ${certlist_file}",
    user    => 'root',
    minute  => "*/${certlist_frequency}",
  }
}
