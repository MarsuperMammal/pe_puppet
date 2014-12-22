# a profile to be referenced by all Puppet Enterprise server roles (aharden@te.com)
class te_puppet::common (
  $backup_dir,
) {
  file { "$backup_dir":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  cron { '/etc/puppetlabs backup':
    ensure  => present,
    command => ". /root/.bashrc; tar -czpf $backup_dir/$::hostname.etc.puppetlabs.tgz /etc/puppetlabs",
    user    => 'root',
    hour    => 1,
    minute  => 0,
  }

  service { 'pe-httpd':
    ensure => running,
    enable => true,
  }
}
