# Profile to be applied to all roles to manage Puppet agent install.
# Note: source and version variables must be stored in osfamily hieradata
# (aharden@te.com)
class te_puppet::agent::install (
  $source,
  $version,
  ) {
  case $::osfamily {
    'aix':     {}
    'debian':  {
      case $::architecture {
        'amd64': {
          $package_name    = 'pe-agent'
          $provider        = 'apt' # default for debian/ubuntu OS
          $package_source  = undef
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
    ensure          => $version,
    provider        => $provider,
    source          => $package_source,
    install_options => $install_options,
  }
}
