class apache2 {

    $sites_available_path = "/etc/apache2/sites-available/$full_project_name.conf" 
    $sites_enabled_path = "/etc/apache2/sites-enabled/$full_project_name.conf"

    package { apache2: ensure => installed}
    package { libapache2-mod-wsgi: ensure => installed}

    service { apache2:
        ensure => running,
        enable => true,
    }

    file {"/etc/apache2/apache2.conf":
        content => template("apache2/apache2.conf.erb"),
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {"/etc/apache2/ports.conf":
        content => template("apache2/ports.conf.erb"),
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {$sites_available_path:
        content => template("apache2/domain.conf.erb"),
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {$sites_enabled_path:
        ensure => link,
        target => $sites_available_path,
    }
}
