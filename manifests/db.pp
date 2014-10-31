class profiles::puppet::db (
  $certificate_list,
) {
  file { '/etc/puppetlabs/puppetdb/certificate-whitelist':
    ensure  => file,
    content => template("${module_name}/puppetdb/certificate-whitelist.erb"),
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0600',
    notify  => Service['pe-puppetdb'],
  }
}
