define djangoapp::instance($client_name="",
                    $project_name="",
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
    $project_path = "/opt/${client_name}/${project_name}/"
    $static_path = "${project_path}current/${python_project_name}/static/"
    $media_path = "${project_path}attachments/"

    $venv = "${webapp::python::venv_root}/$name"
    $src = "${webapp::python::src_root}/$name"

    nginx::site { $full_project_name:
      domains => $domains,
      aliases => $aliases,
      root => "/var/www/$name",
      media_url => $media_root,
      mediaprefix => $mediaprefix,
      upstreams => ["unix:${socket}"],
      owner => $owner,
      group => $group,
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
  }
}
