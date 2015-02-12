# a profile for servers with the Puppet Enterprise PuppetDB role installed (aharden@te.com)
# re-evaluating this management for PE 3.7
class te_puppet::db (
  $certificate_list,
) {
  case $::pe_version {
    '3.3.2': {

      file { '/etc/puppetlabs/puppetdb/certificate-whitelist':
        ensure  => file,
        content => template("${module_name}/puppetdb/certificate-whitelist.erb"),
        owner   => 'pe-puppetdb',
        group   => 'pe-puppetdb',
        mode    => '0600',
        notify  => Service['pe-puppetdb'],
      }
    }
  }
}
