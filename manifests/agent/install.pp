# Profile to be applied to all roles to manage Puppet agent install.
# Note: source and version variables must be stored in osfamily hieradata
# (aharden@te.com)
class te_puppet::agent::install (
  $source = undef,
  $version = undef,
  ) {
  # build agent string
  # reference:
  $myoperatingsystem = downcase($::operatingsystem)
  $agent = "${myoperatingsystem}-${::operatingsystemrelease}-${::architecture}"

  case $::osfamily {
    'aix':     {}
    'debian':  {
      # add PE server as apt source
      file { '/etc/apt/puppet-enterprise.gpg.key':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => "puppet:///modules/${module_name}/puppet-enterprise.gpg.key",
      }

      apt_key { 'puppet-enterprise':
        ensure => 'present',
        id     => '4BD6EC30',
        source => '/etc/apt/puppet-enterprise.gpg.key',
      }

      apt::source { 'puppet-enterprise':
        location => "https:/${::settings::server}:8140/packages/current/${agent}",
        repos    => './',
      }

      case $::architecture {
        'amd64': {
          $package_name    = 'pe-agent'
          $provider        = 'apt' # default for debian/ubuntu OS
          $package_source  = 'puppet-enterprise'
          $install_options = undef
        }
        default: {
          notify { "Unsupported Debian architecture ${::architecture}.": }
        }
      }
    }
    'redhat':  {}
    'solaris': {}
    'windows': {
      case $::architecture {
        'x86': {
          $package_msi  = "puppet-enterprise-${version}.msi"
          $package_name = 'Puppet Enterprise'
        }
        'x64': {
          $package_msi  = "puppet-enterprise-${version}-x64.msi"
          $package_name = 'Puppet Enterprise (64-bit)'
        }
        default: {
          notify { "Unsupported Windows architecture ${::architecture}.": }
        }
      }
      #build source UNC
      $package_source  = "${source}\\${version}\\${package_msi}"

      $provider        = 'windows' #default for ::osfamily windows
      $install_options = ["PUPPET_MASTER_SERVER=${::settings::ca_server}"]
    }
    default: {
      notify { "Unsupported OS family ${::osfamily}.": }
    }
  }
  package { $package_name:
    ensure          => 'latest',
    provider        => $provider,
    source          => $package_source,
    install_options => $install_options,
  }
}
