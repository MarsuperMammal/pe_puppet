# profile to be applied to the Puppet project backup server (aharden@te.com)
# should be included in roles::puppet::backup
class te_puppet::backup (
  $backup_path,
) {
  include ::rsync
  include ::rsync::server
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
