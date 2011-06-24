class apache2 {

    package { "apache2": ensure => installed}
    package { "libapache2-mod-wsgi": ensure => installed}

    service { apache2:
        ensure => running,
        enable => true,
        hasrestart => true,
    }

    file {"/etc/apache2/apache2.conf":
        path => "/etc/apache2/apache2.conf",
        source => "puppet:///modules/apache2/apache2.cnf",
        require => Package["apache2"],
        notify => Service["apache2"],
    }

    file {"ports.conf":
        path => "/etc/apache2/ports.conf",
        source => "puppet:///modules/apache2/ports.cnf",
        require => Package["apache2"],
        notify => Service["apache2"],
    }
}
