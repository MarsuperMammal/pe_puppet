# profile to include on Puppet Enterprise masters acting as CA (aharden@te.com)
class te_puppet::master::ca (
  $certlist_file,
  $certlist_frequency,
) {
  include ::limits
  include ::te_puppet::master

  ini_setting { 'Enable autosigning':
    ensure  => present,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'autosign',
    value   => '$confdir/autosign.conf',
    notify  => 'pe-puppetserver',
  }

  file { "${::settings::confdir}/autosign.conf":
    ensure => file,
    source => "puppet:///modules/${module_name}/autosign.conf",
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
    notify => 'pe-puppetserver',
  }

  file { "${::settings::confdir}/fileserver.conf":
    ensure => file,
    source => "puppet:///modules/${module_name}/puppet-ca/fileserver.conf",
    owner  => 'root',
    group  => 'pe-puppet',
    mode   => '0644',
  }
  
  cron { 'export certlist to file':
    ensure  => present,
    command => ". /root/.bashrc; /usr/local/bin/puppet cert list --all > ${certlist_file}",
    user    => 'root',
    minute  => "*/${certlist_frequency}",
  }
}
