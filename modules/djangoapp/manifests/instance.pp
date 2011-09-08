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


    # If you add any more path variables,
    # KEEP A TRAILING SLASH!!
    
    $full_project_name = "${client_name}_${project_name}"
    $client_path = "/opt/${client_name}/"
    $project_path = "${client_path}${project_name}/"
    $venv_path = "${project_path}venv/"
    $src_path = "${project_path}src/"
    $python_src_path = "${src_path}${python_dir_name}/"
    $releases_path = "${project_path}releases/"
    $deployment_current_path = "${project_path}current/"
    $deployment_etc_path = "${project_path}etc/"

    $development_static_path = "${python_src_path}static/"
    $development_media_path = "${python_src_path}attachments/"
    $production_static_path = "${project_path}static/"
    $production_media_path = "${project_path}attachments/"
    $project_wsgi_path = "${deployment_etc_path}${full_project_name}.wsgi"
    
    $server_type = $machine::server_type

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

        # Create project level directories.
        
        file { $project_path:
            ensure  => directory,
            owner   => $owner,
            group   => $group,
            mode    => 775,
            require => File[$client_path],
        }

        if ( $server_type != 'vagrant') {

            file { $production_static_path:
                ensure  => directory,
                owner   => $owner,
                group   => $group,
                mode    => 664, # rw, rw, r
                require => File[$project_path],
            }

            file { $production_media_path:
                ensure  => directory,
                owner   => $owner,
                group   => $group,
                mode    => 664, # rw, rw, r
                require => File[$project_path],
            }
        }

        file { $releases_path:
            ensure  => directory,
            owner   => $owner,
            group   => $group,
            mode    => 664, # rw, rw, r
            require => File[$project_path],
        }

        file { $deployment_etc_path:
            ensure  => directory,
            owner   => $owner,
            group   => $group,
            mode    => 664, # rw, rw, r
            require => File[$project_path],
        }
    }

    # Create the wsgi file.
    apache2::mod_wsgi::setup { $project_wsgi_path:
        venv_path   => $venv_path,
        server_type => $server_type,
        python_dir_name => $python_dir_name,
        deployment_current_path => $deployment_current_path,
        deployment_etc_path => $deployment_etc_path,
        owner       => $owner,
        group       => $group,
    }

    # Create a virtualenv and run the requirements file.
    python2::venv::setup { $venv_path:
        requirements => false,
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
        djangoapp::development::setup { $full_project_name: 
                                         project_path => $project_path,
                                         src_path     => $src_path,
                                         owner        => "deployer",
                                         group        => $group,
                                       }
    } else {
        djangoapp::production::setup { $full_project_name: 
                                         project_path => $project_path,
                                         src_path     => $src_path,
                                         owner        => "deployer",
                                         group        => $group,
                                       }
    }
}
