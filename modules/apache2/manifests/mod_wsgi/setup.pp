
define apache2::mod_wsgi::setup($venv_path,
                                $server_type,
                                $python_dir_name,
                                $deployment_current_path,
                                $owner="deployer",
                                $group="www-data") {

    $project_wsgi_path = $name

    file {$project_wsgi_path:
        content => template("apache2/mod_wsgi/project.wsgi.erb"),
        require => [
                    File[$djangoapp::deployment_etc_path],
                    Package["apache2"],
                    Package["libapache2-mod-wsgi"],
                   ],
        notify  => Service["apache2"],
        owner   => $owner,
        group   => $group,
        mode    => 444,
    }
}
