class nginx {

    $sites_available_path = "/etc/nginx/sites-available/$full_project_name.conf" 
    $sites_enabled_path = "/etc/nginx/sites-enabled/$full_project_name.conf"

    package { nginx: ensure => installed }

    service { nginx:
        ensure => running,
        enable => true
    }

    file {"/etc/nginx/nginx.conf":
        content => template("nginx/nginx.conf.erb"),
        require => Package["nginx"],
        notify => Service["nginx"]
    }

    file {$sites_available_path:
        content => template("nginx/nginx.conf.erb"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }

    file {$sites_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
