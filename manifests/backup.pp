# profile to be applied to the Puppet project backup server (aharden@te.com)
# should be included in roles::puppet::backup
class te_puppet::backup {
  include ::rsync
  include ::rsync::server
  $backup_path = $::te_puppet::common::rsync_dest_path

  # setup PE server backup repo
  file { $backup_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  rsync::server::module { 'PE_repo':
    path    => $backup_path,
    require => File[$backup_path],
  }
}
