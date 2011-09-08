define apache2::site($production_domain,
                     $staging_domain,
                     $owner="www-data",
                     $group="www-data") {

    $sites_available_path = "/etc/apache2/sites-available/${djangoapp::full_project_name}.conf" 
    $sites_enabled_path = "/etc/apache2/sites-enabled/${djangoapp::full_project_name}.conf"

    file {$sites_available_path:
        content => template("apache2/project.conf.erb"),
        require => Package["apache2"],
        notify  => Service["apache2"],
        owner   => "root",
        group   => "root",
    }

    file {$sites_enabled_path:
        ensure  => link,
        target  => $sites_available_path,
        require => Package["apache2"],
        notify  => Service["apache2"],
        owner   => "root",
        group   => "root",
    }
}
