# Adapted from github.com/uggedal/puppet-module-webapp
# with massive thanks to Eivind Uggedal.

define python2::venv::setup($requirements=undef) {

    # TODO: Initial requirements loading?
    # Done with an internally build script for now..

    $venv_path = $name

    # Does not successfully run as deployer for some reason.
    exec { "python2::venv $venv_path":
      command => "virtualenv ${venv_path}",
      creates => $venv_path,
      path   => "/usr/local/bin:/usr/bin:/bin",
      notify => Exec["update distribute and pip in $venv_path"],
      require => [
                    Package["python"],
                    Package["python-dev"],
                    Package["python-virtualenv"],
                ],
    }

    # Change ownership of the venv after its created.
    exec { "python2::venv $venv_path chown":
      command => "chown -R deployer:www-data $venv_path",
      path   => "/usr/local/bin:/usr/bin:/bin",
      require => Exec["python2::venv $venv_path"],
    }

    # Some newer Python packages require an updated distribute
    # from the one that is in repos on most systems:
    exec { "update distribute and pip in $venv_path":
      command => "${venv_path}bin/pip install -U distribute pip",
      refreshonly => true,
    }
}
