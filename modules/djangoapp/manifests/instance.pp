define djangoapp::instance($client_name="",
                           $project_name="",
                           $python_dir_name="",
                           $production_domain="",
                           $staging_domain="",
                           $owner="www-data",
                           $group="www-data",
                           $static_url="/static/",
                           $media_url="/media/",
                           $git_checkout_url="",
                           $requirements=false) {

    # Test to see if this is a vagrant 
    # machine or a non-local-virtual setup.

    if ( 'vagrant' in $hostname ) {
        $server_type = 'vagrant'
    } else {
        $server_type = 'server'
    }

    #TODO: clean these up, some have trailing slashes,
    # some do not, this is highly annoying when it comes
    # to templating and variable insertion.

    $full_project_name = "${client_name}_${project_name}"
    $client_path = "/opt/${client_name}/"
    $project_path = "${client_path}${project_name}/"
    $static_path = "${project_path}current/${python_dir_name}/static/"
    $media_path = "${project_path}attachments/"

    $venv_path = "${project_path}venv"
    $src_path = "${project_path}src"
    
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

    # Create client and project paths
    # if they do not currently exist.
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

    }

    # Create a virtualenv and run the requirements file.
    python2::venv::setup { $venv_path:
        requirements => $requirements ? {
            true => "$src_path/requirements.pip",
            default => undef,
        },
        require => Exec["source-checkout"],
    }

    # Create the site specific nginx conf.
    nginx::site { $full_project_name:
      production_domain => $production_domain,
      staging_domain => $staging_domain,
      owner => $owner,
      group => $group,
      media_url => $media_url,
      static_url => $static_url,
    }

    # Create the site specific Apache conf.
    apache2::site { $full_project_name:
      production_domain => $production_domain,
      staging_domain => $staging_domain,
      owner => $owner,
      group => $group,
    }
    
    # Create the MySQL database, this will do
    # nothing if it already exists.
    mysql::createdb { $full_project_name:
        db_name => $full_project_name,
        db_user => $full_project_name,
        db_pass => $full_project_name,
    }

    # Here we split depending on if this is a Vagrant
    # machine or our actual staging/production.
    if ( $server_type == 'vagrant' ) {
        deployment::development::setup { $full_project_name: 
                                         project_path => $project_path,
                                         src_path     => $src_path,
                                         owner        => "deployer",
                                         group        => $group,
                                       }
    } else {
        deployment::production::setup { $full_project_name: 
                                         project_path => $project_path,
                                         src_path     => $src_path,
                                         owner        => "deployer",
                                         group        => $group,
                                       }
    }
}
