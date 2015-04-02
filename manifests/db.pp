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

  # cron job to produce full DB backup on disk
  # https://docs.puppetlabs.com/pe/3.7/maintain_console-db.html#database-backups
  cron { 'Full DB backup':
    command => "/opt/puppet/bin/pg_dumpall -f ${bkup_folder}fulldb.backup",
  }
}
