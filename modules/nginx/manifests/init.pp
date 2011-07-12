class nginx {

    package { "nginx": ensure => installed }

    service { "nginx":
        ensure => running,
        enable => true,
        hasrestart => true,
        require => [
                    Package["nginx"],
                   ],
    }

    file { "nginx.conf":
        path => "/etc/nginx/nginx.conf",
        source => "puppet:///modules/nginx/nginx.conf",
        require => Package["nginx"],
        notify => Service["nginx"],
        owner => "root",
        group => "root",
    }

    file { "nginx/sites-available/default":
        path => "/etc/nginx/sites-available/default",
        source => "puppet:///modules/nginx/sites-available/default",
        require => Package["nginx"],
        notify => Service["nginx"],
        owner => "root",
        group => "root",
    }
}
