
define nginx::site($domains,
                   $owner="www-data",
                   $group="www-data",
                   $media_url="/media/",
                   $static_url="/static/") { 

    $sites_available_path = "/etc/nginx/sites-available/${full_project_name.conf" 
    $sites_enabled_path = "/etc/nginx/sites-enabled/$full_project_name.conf"

    file {$sites_available_path:
        content => template("nginx/project.conf.erb"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }

    file {$sites_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
