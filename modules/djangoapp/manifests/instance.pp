djangoapp::instance($live_domain,
                    $aliases=[],
                    $owner="www-data",
                    $group="www-data",
                    $mediaroot="",
                    $mediaprefix="",
                    $wsgi_module="",
                    $requirements=false) {


    #TODO: make these work off the kwargs coming in!!
    settings['full_project_name'] = "#{settings['client_name']}_#{settings['project_name']}"
    settings['project_path'] = "/opt/#{settings['client_name']}/#{settings['project_name']}/"
    settings['static_path'] = "#{settings['project_path']}current/#{settings['python_project_name']}/static/"
    settings['media_path'] = "#{settings['project_path']}attachments/"

    $venv = "${webapp::python::venv_root}/$name"
    $src = "${webapp::python::src_root}/$name"

    $pidfile = "${python::gunicorn::rundir}/${name}.pid"
    $socket = "${python::gunicorn::rundir}/${name}.sock"

    nginx::site { $name:
      ensure => $ensure,
      domain => $domain,
      aliases => $aliases,
      root => "/var/www/$name",
      mediaroot => $mediaroot,
      mediaprefix => $mediaprefix,
      upstreams => ["unix:${socket}"],
      owner => $owner,
      group => $group,
      # require apache to be loaded first.
      #require => Python::Gunicorn::Instance[$name],
    }

    apache2::site { $name:
      ensure => $ensure,
      domain => $domain,
      root => "/var/www/$name",
      upstreams => ["unix:${socket}"],
      owner => $owner,
      group => $group,
    }

    python::venv::isolate { $venv:
      ensure => $ensure,
      requirements => $requirements ? {
        true => "$src/requirements.txt",
        default => undef,
      },

    mysql::createdb {

    }
  }
}
