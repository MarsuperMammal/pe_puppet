# a profile to apply to PuppetDB servers to backup DBs to local disk (aharden@te.com)
class te_puppet::db::backup (
  $folder = '/tmp/',
  $hours = ['1'], # which hours to back up at daily
) {
  include ::rsync

  $rsync_dest_host = $::te_puppet::common::rsync_dest_host
  $rsync_dest_path = $::te_puppet::common::rsync_dest_path

  Cron {
    ensure => present,
    user   => 'pe-postgres',
    hour   => $hours,
    minute => '0',
  }

  file { $folder:
    ensure => 'directory',
    mode   => '0775',
    owner  => 'pe-postgres',
    group  => 'pe-postgres',
  }

  # cron jobs to produce hourly DB snapshots on disk
  cron { 'PuppetDB backup':
    command => "/opt/puppet/bin/pg_dump pe-puppetdb -f ${folder}pe-puppetdb.backup --create",
  }
  cron { 'Console DB backup':
    command => "/opt/puppet/bin/pg_dump console -f ${folder}console.backup --create",
  }
  cron { 'Console_auth DB backup':
    command => "/opt/puppet/bin/pg_dump console_auth -f ${folder}console_auth.backup --create",
  }

  #rsync target for DB file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}":
    user   => 'root',
    source => $folder,
  }
}
