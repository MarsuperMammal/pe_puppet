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

# cleaning up after abandoned backups from old code
  File {
    ensure => 'absent',
  }

  file { "${bkup_folder}console.backup":}
  file { "${bkup_folder}pe-activity.backup":}
  file { "${bkup_folder}pe-classifier.backup":}
  file { "${bkup_folder}pe-puppetdb.backup":}
  file { "${bkup_folder}pe-rbac.backup":}
# end cleaning up (remove in next version)

  file { $bkup_folder:
    ensure => 'directory',
    mode   => '0775',
    owner  => 'pe-postgres',
    group  => 'pe-postgres',
  }

  # cron job to produce full DB backup on disk
  # https://docs.puppetlabs.com/pe/3.7/maintain_console-db.html#database-backups
  cron { 'Full DB backup':
    command => "/opt/puppet/bin/pg_dumpall -f ${bkup_folder}dumpall.backup",
  }
  cron { 'Console DB backup':
    ensure  => absent,
    command => "/opt/puppet/bin/pg_dump -Fc -C -c console -f ${bkup_folder}console.backup",
  }
  cron { 'Activity DB backup':
    ensure  => absent,
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-activity -f ${bkup_folder}pe-activity.backup",
  }
  cron { 'Classifier DB backup':
    ensure  => absent,
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-classifier -f ${bkup_folder}pe-classifier.backup",
  }
  cron { 'RBAC DB backup':
    ensure  => absent,
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-rbac -f ${bkup_folder}pe-rbac.backup",
  }
  cron { 'PuppetDB backup':
    ensure  => absent,
    command => "/opt/puppet/bin/pg_dump -Fc -C -c pe-puppetdb -f ${bkup_folder}pe-puppetdb.backup",
  }
}
