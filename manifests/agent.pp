class profiles::puppet::agent (
  $server,
  $ca_server,
  $archive_file_server,
  $ensure = 'running',
  $enable = true,
) {
  if $::osfamily == 'windows' {
    $appdata = regsubst($::common_appdata,'\\','/','G')
    $confdir = "${appdata}/PuppetLabs/puppet/etc"
  } else {
    $confdir = '/etc/puppetlabs/puppet'
  }
  Ini_setting {
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'main',
    notify  => Service['pe-puppet'],
  }
  ini_setting { 'puppet master server setting':
    setting => 'server',
    value   => $server,
  }
  ini_setting { 'puppet ca server setting':
    setting => 'ca_server',
    value   => $ca_server,
  }
  ini_setting { 'puppet filebucket server setting':
    setting => 'archive_file_server',
    value   => $archive_file_server,
  }
  service { 'pe-puppet':
    ensure => $ensure,
    enable => $enable,
  }
}
