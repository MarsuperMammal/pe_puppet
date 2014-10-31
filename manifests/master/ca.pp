class profiles::puppet::master::ca {
  include ::profiles::puppet::master
  include ::r10k::webhook
  include ::r10k::webhook::config
  Class['::r10k::webhook::config'] -> Class['::r10k::webhook']

  ini_setting { 'Enable autosigning':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'autosign',
    value   => '$confdir/autosign.conf',
    notify  => Service['pe-httpd'],
  }

  file { "${::settings::confdir}/autosign.conf":
    ensure => file,
    source => "puppet:///modules/${module_name}/autosign.conf",
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
    notify => Service['pe-httpd'],
  }

  file { "${::settings::confdir}/fileserver.conf":
    ensure => file,
    source => "puppet:///modules/${module_name}/puppet-ca/fileserver.conf",
    owner  => 'root',
    group  => 'pe-puppet',
    mode   => '0644',
  }
}
