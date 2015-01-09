# profile to be applied to Puppet Enterprise Console servers (aharden@te.com)
# puppetversion case can be removed after decom of PE 3.3.2
class te_puppet::console (
  $certificate_list,
  $console_auth_pwd,
  $console_db_pwd,
  $ldap_pwd,
  $db_host = 'localhost',
) {
  include ::te_puppet::common
  include ::rsync
  $rsync_dest_host = $::te_puppet::common::rsync_dest_host
  $rsync_dest_path = $::te_puppet::common::rsync_dest_path

  File {
    owner  => 'pe-auth',
    group  => 'puppet-dashboard',
    mode   => '0640',
    notify => Service['pe-puppet-dashboard-workers','pe-httpd'],
  }

  case $::pe_version {
    '3.3.2': {
      $database_yml_file = 'database.yml.pe33.erb'

      file {'/etc/puppetlabs/console-auth/cas_client_config.yml':
        ensure => 'file',
        source => "puppet:///modules/${module_name}/console-auth/cas_client_config.yml",
      }

      file {'/etc/puppetlabs/rubycas-server/config.yml':
        ensure  => 'file',
        content => template("${module_name}/rubycas-server/config.yml.erb"),
        group   => 'pe-auth',
        mode    => '0600',
      }
    }
    default: {
      $database_yml_file = 'database.yml.erb'

      # Config file to control session duration
      # Reference: https://docs.puppetlabs.com/pe/latest/console_config.html
      file {'/etc/puppetlabs/console-services/conf.d/session-duration.conf':
        ensure => 'file',
        source => "puppet:///modules/${module_name}/console-services/session-duration.conf",
        group  => 'pe-console-services',
        user   => 'pe-console-services',
        mode   => '0640',
        notify => Service['pe-console-services'],
      }

      service {'pe-console-services':
        ensure => 'running',
        enable => true,
      }
    }
  }

  file {'/etc/puppetlabs/puppet-dashboard/database.yml':
    ensure  => file,
    content => template("${module_name}/puppet-dashboard/$database_yml_file"),
    owner   => 'puppet-dashboard',
  }

  file {'/etc/puppetlabs/console-auth/certificate_authorization.yml':
    ensure  => file,
    content => template("${module_name}/console-auth/certificate_authorization.yml.erb"),
  }

  # rsync target for /opt/puppet/share/puppet-dashboard/certs file backups
  rsync::put { "${rsync_dest_host}:${rsync_dest_path}/${::puppetdeployment}/${::hostname}\
    /opt/puppet/share/puppet-dashboard/certs":
    user   => 'root',
    source => '/opt/puppet/share/puppet-dashboard/certs',
  }

  service {'pe-puppet-dashboard-workers':
    ensure => 'running',
    enable => true,
  }
}
