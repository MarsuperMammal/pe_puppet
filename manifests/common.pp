# a profile to be referenced by all Puppet Enterprise server roles
# Alex Harden (aharden@te.com)
class te_puppet::common (
  $license_end_date,
  $license_nodes,
  $rsync_dest_host,
  $rsync_dest_path,
) {
  include ::rsync

  #PE license file
  file { '/etc/puppetlabs/license.key':
    ensure  => 'file',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/license.key.erb"),
  }

  #rsync target for /etc/puppetlabs file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}/etc/puppetlabs":
    user    => 'root',
    keyfile => '/root/.ssh/id_rsa',
    source  => '/etc/puppetlabs/',
  }

  case $::pe_version {
    '3.3.2': {
      service { 'pe-httpd':
        ensure => 'running',
        enable => true,
      }
    }
    default: {}
  }
}
