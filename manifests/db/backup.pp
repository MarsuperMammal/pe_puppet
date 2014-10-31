class profiles::puppet::db::backup (
  $folder = '/tmp/',
  $frequency = '60', # in minutes
) {
  Cron {
    ensure => present,
    user   => 'pe-postgres',
    minute => "*/${frequency}",
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
}
