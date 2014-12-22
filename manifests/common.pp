# a profile to be referenced by all Puppet Enterprise server roles (aharden@te.com)
class te_puppet::common {
  cron { '/etc/puppetlabs backup':
    ensure  => present,
    command => ". /root/.bashrc; tar -czpf /tmp/$::hostname.etc.puppetlabs.tgz /etc/puppetlabs"
    user    => 'root',
    hour    => 1,
    minute  => 0,
  }

  service { 'pe-httpd':
    ensure => running,
    enable => true,
  }
}
