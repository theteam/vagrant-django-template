# Adapted from github.com/uggedal/puppet-module-webapp
# with massive thanks to Eivind Uggedal.

define python2::venv::setup($requirements=undef) {

    $venv_path = $name
    $owner = $python::venv::owner
    $group = $python::venv::group

    # Does not successfully run as www-data on Debian:
    exec { "python::venv $venv_path":
      command => "virtualenv -p `which ${python}` ${venv_path}",
      creates => $root,
      notify => Exec["update distribute and pip in $venv_path"],
      require => [Package["python-dev"]],
    }

    # Change ownership of the venv after its created with the default user:
    exec { "python::venv $root chown":
      command => "chown -R $owner:$group $root",
      onlyif => "find $root ! (-user $owner -group $group)",
      require => Exec["python::venv $root"],
    }

    # Some newer Python packages require an updated distribute
    # from the one that is in repos on most systems:
    exec { "update distribute and pip in $root":
      command => "$root/bin/pip install -U distribute pip",
      refreshonly => true,
    }

    if $requirements {
      python::pip::requirements { $requirements:
        venv => $root,
        owner => $owner,
        group => $group,
      }
    }

    } elsif $ensure == 'absent' {

    file { $root:
      ensure => $ensure,
      owner => $owner,
      group => $group,
      recurse => true,
      purge => true,
      force => true,
    }
}
