# Adapted from github.com/uggedal/puppet-module-webapp
# with massive thanks to Eivind Uggedal.

define python2::venv::setup($version=latest,
                            $requirements=undef) {
  $root = $name
  $owner = $python::venv::owner
  $group = $python::venv::group

  if $ensure == 'present' {
    # Parent directory of root directory. /var/www for /var/www/blog
    $root_parent = inline_template("<%= root.match(%r!(.+)/.+!)[1] %>")

    if !defined(File[$root_parent]) {
      file { $root_parent:
        ensure => directory,
        owner => $owner,
        group => $group,
      }
    }

    $python = $version ? {
      'latest' => "python",
      default => "python${version}",
    }

    # Does not successfully run as www-data on Debian:
    exec { "python::venv $root":
      command => "virtualenv -p `which ${python}` ${root}",
      creates => $root,
      notify => Exec["update distribute and pip in $root"],
      require => [File[$root_parent],
                  Package["${python}-dev"]],
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
}
