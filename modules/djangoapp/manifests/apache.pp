class djangoapp::apache {

    $apache_available_path = "/etc/apache2/sites-available/$full_project_name.conf" 
    $apache_enabled_path = "/etc/apache2/sites-enabled/$full_project_name.conf"

    file {$apache_available_path:
        content => template("apache2/domain.conf.erb"),
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {$apache_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
