# a module to be used by all Puppet Enterprise server roles
# Alex Harden (aharden@te.com)
class te_puppet (
  $diskmon,  # array of file systems to monitor - receive from hiera
) {
  $ito_path = '/etc/opt/ITO'

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { $ito_path:
    ensure => 'directory',
  }

  file { "${ito_path}/dsku0001.mpconfig":
    ensure  => 'file',
    content => template("${module_name}/dsku0001.mpconfig.erb"),
  }
}
