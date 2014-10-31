class profiles::puppet::common {
  service { 'pe-httpd':
    ensure => running,
    enable => true,
  }
}
