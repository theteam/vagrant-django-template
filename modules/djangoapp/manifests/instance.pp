define djangoapp::instance($client_name="",
                    $project_name="",
                    $python_dir_name="",
                    $domains={},
                    $owner="www-data",
                    $group="www-data",
                    $static_url="/static/",
                    $media_url="/media/",
                    $requirements=false) {
    
    include aptitude
    include iptables
    include logrotate
    include denyhosts
    include apache2
    include nginx
    include memcached
    include mysql
    include python2

    $full_project_name = "${client_name}_${project_name}"
    $client_path = "/opt/${client_name}/"
    $project_path = "${client_name}${project_name}/"
    $static_path = "${project_path}current/${python_dir_name}/static/"
    $media_path = "${project_path}attachments/"

    $venv = "${webapp::python::venv_root}/$name"
    $src = "${webapp::python::src_root}/$name"


    # Create client and project paths if they
    # do not currently exist.
    if !defined(File[$client_path]) {
        
        file { $client_path:
            ensure => directory,
            owner => $owner,
            group => $group
        }
    }

    if !defined(File[$project_path]) {
        
        file { $project_path:
            ensure => directory,
            owner => $owner,
            group => $group,
        
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

    #mysql::createdb {
    #
    #}

    # Everything is in place, deploy!
    djangoapp::deploy(
        project_path => $project_path,
        project_checkout_dir => $project_checkout_dir)
}
