# profile to be applied to Puppet Enterprise Console servers (aharden@te.com)
class te_puppet::console (
  $certificate_list,
  $console_auth_pwd,
  $console_db_pwd,
  $ldap_pwd,
  $db_host = 'localhost',
) {
  include ::te_puppet::common
  File {
    owner  => 'pe-auth',
    group  => 'puppet-dashboard',
    mode   => '0640',
    notify => Service['pe-puppet-dashboard-workers','pe-httpd'],
  }

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

  file {'/etc/puppetlabs/puppet-dashboard/database.yml':
    ensure  => file,
    content => template("${module_name}/puppet-dashboard/database.yml.erb"),
    owner   => 'puppet-dashboard',
  }

  file {'/etc/puppetlabs/console-auth/certificate_authorization.yml':
    ensure  => file,
    content => template("${module_name}/console-auth/certificate_authorization.yml.erb"),
  }

  service {'pe-puppet-dashboard-workers':
    ensure => 'running',
    enable => true,
  }
}
