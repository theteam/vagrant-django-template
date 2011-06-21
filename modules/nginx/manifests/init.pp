class nginx {
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
}
