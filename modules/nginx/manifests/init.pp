class nginx {


    package { nginx: ensure => installed }

    service { nginx:
        ensure => running,
        enable => true
    }

    file {"nginx.conf":
        path => "/etc/nginx/nginx.conf",
        source => "puppet:///modules/nginx/nginx.conf",
        require => Package["nginx"],
        notify => Service["nginx"]
    }
}
