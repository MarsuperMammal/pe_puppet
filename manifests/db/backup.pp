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
  # https://docs.puppetlabs.com/pe/3.7/maintain_console-db.html#database-backups
  cron { 'Console DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c console -f ${folder}console.backup --create",
  }
  cron { 'Activity DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-activity -f ${folder}pe-activity.backup --create",
  }
  cron { 'Classifier DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-classifier -f ${folder}pe-classifier.backup --create",
  }
  cron { 'RBAC DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-rbac -f ${folder}pe-rbac.backup --create",
  }
  cron { 'PuppetDB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-puppetdb -f ${folder}pe-puppetdb.backup --create",
  }

  #rsync target for DB file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}":
    user   => 'root',
    source => $folder,
  }
}
