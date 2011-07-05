define djangoapp::instance($client_name="",
                    $project_name="",
                    $python_dir_name="",
                    $domains={},
                    $owner="www-data",
                    $group="www-data",
                    $static_url="/static/",
                    $media_url="/media/",
                    $git_checkout_url="",
                    $requirements=false) {
    
    include aptitude
    include deployment
    include sshd
    include iptables
    include logrotate
    include denyhosts
    include apache2
    include nginx
    include memcached
    include mysql
    include python2
    include version_control

    $full_project_name = "${client_name}_${project_name}"
    $client_path = "/opt/${client_name}/"
    $project_path = "${client_path}${project_name}/"
    $static_path = "${project_path}current/${python_dir_name}/static/"
    $media_path = "${project_path}attachments/"

    $venv_path = "${project_path}venv/"
    $src_path = "${project_path}src/"

    # Create client and project paths if they
    # do not currently exist.
    if !defined(File[$client_path]) {
        
        file { $client_path:
            ensure => directory,
            owner  => $owner,
            group  => $group,
            mode   => 775,
        }
    }

    if !defined(File[$project_path]) {
        
        file { $project_path:
            ensure  => directory,
            owner   => $owner,
            group   => $group,
            mode    => 775,
            require => File[$client_path],
        }

        exec { "source-checkout":
            unless  => "test -d $src_path",
            path   => "/usr/local/bin:/usr/bin:/bin",
            user => "deployer",
            group => $group,
            command => "git clone $git_checkout_url $src_path",
            require => [
                        Package["git-core"],
                        File["ssh-known-hosts"],
                        File["ssh-public-key"],
                        File["ssh-private-key"],
                        File[$project_path],
                       ],
        }

        exec { "setup-virtualenv":
            unless  => "test -d $venv_path",
            path    => "/usr/local/bin:/usr/bin:/bin",
            user    => "deployer",
            group   => $group,
            command => "virtualenv $venv_path",
            require => [
                        Exec["source-checkout"],
                       ],
        }
    }

    nginx::site { $full_project_name:
      domains => $domains,
      owner => $owner,
      group => $group,
      media_url => $media_url,
      static_url => $static_url,
    }

    apache2::site { $full_project_name:
      domains => $domains,
      owner => $owner,
      group => $group,
    }

    #python::venv::isolate { $venv:
    #  requirements => $requirements ? {
    #    true => "$src/requirements.txt",
    #    default => undef,
    #  },
    #
    
    # Create the MySQL database, this will do
    # nothing if it already exists.
    mysql::createdb { $full_project_name:
        db_name => $full_project_name,
        db_user => $full_project_name,
        db_pass => $full_project_name,
    }
}
