class djangoapp::nginx {

    $nginx_available_path = "/etc/nginx/sites-available/$full_project_name.conf" 
    $nginx_enabled_path = "/etc/nginx/sites-enabled/$full_project_name.conf"

    file {$sites_available_path:
        content => template("nginx/domain.conf.erb"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }

    file {$sites_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
