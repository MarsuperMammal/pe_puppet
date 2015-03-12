# a profile for servers with the Puppet Enterprise PuppetDB role installed
# ALex Harden (aharden@te.com)
class te_puppet::db (
  $bkup_folder = '/tmp/',
  $bkup_hours = ['1'], # which hours to back up at daily
) {
  Cron {
    ensure => present,
    user   => 'pe-postgres',
    hour   => $bkup_hours,
    minute => '0',
  }

  file { $bkup_folder:
    ensure => 'directory',
    mode   => '0775',
    owner  => 'pe-postgres',
    group  => 'pe-postgres',
  }

  # cron jobs to produce DB snapshots on disk
  # https://docs.puppetlabs.com/pe/3.7/maintain_console-db.html#database-backups
  cron { 'Console DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c console -f ${bkup_folder}console.backup",
  }
  cron { 'Activity DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-activity -f ${bkup_folder}pe-activity.backup",
  }
  cron { 'Classifier DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-classifier -f ${bkup_folder}pe-classifier.backup",
  }
  cron { 'RBAC DB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-rbac -f ${bkup_folder}pe-rbac.backup",
  }
  cron { 'PuppetDB backup':
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-puppetdb -f ${bkup_folder}pe-puppetdb.backup",
  }
}
