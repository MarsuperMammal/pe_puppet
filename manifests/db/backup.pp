# a profile to apply to PuppetDB servers to backup DBs to local disk (aharden@te.com)
class te_puppet::db::backup (
  $folder = '/tmp/',
  $hours = ['1'], # which hours to back up at daily
) {
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

  # cron jobs to produce DB snapshots on disk
  # https://docs.puppetlabs.com/pe/3.7/maintain_console-db.html#database-backups
  cron { 'Console DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c console -f ${folder}console.backup",
  }
  cron { 'Activity DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-activity -f ${folder}pe-activity.backup",
  }
  cron { 'Classifier DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-classifier -f ${folder}pe-classifier.backup",
  }
  cron { 'RBAC DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-rbac -f ${folder}pe-rbac.backup",
  }
  cron { 'PuppetDB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-puppetdb -f ${folder}pe-puppetdb.backup",
  }
}
