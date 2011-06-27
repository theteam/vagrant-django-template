define apache2::site($domains,
                     $owner="www-data",
                     $group="www-data") {

    $sites_available_path = "/etc/apache2/sites-available/$full_project_name.conf" 
    $sites_enabled_path = "/etc/apache2/sites-enabled/$full_project_name.conf"

    file {$sites_available_path:
        content => template("apache2/project.conf.erb"),
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {$sites_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
