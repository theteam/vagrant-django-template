# Adapted from https://github.com/uggedal/puppet-module-python
# Thanks to Eivind Uggedal.
define python2::pip::requirements($venv, $owner=undef, $group=undef) {
  $requirements = $name
  $checksum = "$venv/requirements.checksum"

  file { $requirements:
    ensure => present,
    replace => false,
    owner => $owner,
    group => $group,
  }

  # We create a sha1 checksum of the requirements file so that
  # we can detect when it changes:
  exec { "create new checksum of $name requirements":
      command => "sha1sum $requirements > $checksum",
      unless => "sha1sum -c $checksum",
      path   => "/usr/local/bin:/usr/bin:/bin",
      require => File[$requirements],
    }

  exec { "update $name requirements":
    command => "$venv/bin/pip install -Ur $requirements",
    cwd => $venv,
    subscribe => Exec["create new checksum of $name requirements"],
    refreshonly => true,
    user => root,
    group => root,
  }
}
