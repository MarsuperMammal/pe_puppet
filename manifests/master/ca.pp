# profile to include on Puppet Enterprise masters acting as CA (aharden@te.com)
class pe_puppet::master::ca (
  $certlist_file,
  $certlist_frequency,
) {
  include ::pe_puppet::master

  ini_setting { 'Enable autosigning':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'autosign',
    value   => '$confdir/autosign.conf',
    notify  => Service['pe-puppetserver'],
  }

  file { "${::settings::confdir}/autosign.conf":
    ensure => file,
    source => "puppet:///modules/${module_name}/autosign.conf",
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
    notify => Service['pe-puppetserver'],
  }
}
