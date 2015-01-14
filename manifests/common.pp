# a profile to be referenced by all Puppet Enterprise server roles (aharden@te.com)
class te_puppet::common (
  $rsync_dest_host,
  $rsync_dest_path,
) {
  include ::rsync

  service { 'rsync':
    ensure => 'running',
    enable => 'true',
  }

  #rsync target for /etc/puppetlabs file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}/etc/puppetlabs":
    user    => 'root',
    keyfile => '/root/.ssh/id_rsa',
    source  => '/etc/puppetlabs/',
  }

  service { 'pe-httpd':
    ensure => 'running',
    enable => 'true',
  }
}
