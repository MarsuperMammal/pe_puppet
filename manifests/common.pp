# a profile to be referenced by all Puppet Enterprise server roles (aharden@te.com)
class te_puppet::common {
  service { 'pe-httpd':
    ensure => running,
    enable => true,
  }
}
