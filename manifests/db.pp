# a profile for servers with the Puppet Enterprise PuppetDB role installed (aharden@te.com)
class te_puppet::db (
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
  #rsync target for /etc/puppetlabs file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}":
    user   => 'root',
    source => '/etc/puppetlabs',
  }
}
