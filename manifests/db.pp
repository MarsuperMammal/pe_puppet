# a profile for servers with the Puppet Enterprise PuppetDB role installed
# ALex Harden (aharden@te.com)
class te_puppet::db (
  $certificate_list,
) {
  include te_puppet::db::backup

  file { '/etc/puppetlabs/puppetdb/certificate-whitelist':
    ensure  => file,
    content => template("${module_name}/puppetdb/certificate-whitelist.erb"),
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0600',
    notify  => Service['pe-puppetdb'],
  }
}
