class apache2 {

    $packages = ["apache2", "libapache2-mod-wsgi", "libapache2-mod-rpaf"]

    package { $packages: ensure => installed}

    service { apache2:
        ensure => running,
        enable => true,
        hasrestart => true,
    }

    file {"/etc/apache2/apache2.conf":
        path => "/etc/apache2/apache2.conf",
        source => "puppet:///modules/apache2/apache2.conf",
        require => Package["apache2"],
        notify => Service["apache2"],
        owner => "root",
        group => "root",
    }

    file {"ports.conf":
        path => "/etc/apache2/ports.conf",
        source => "puppet:///modules/apache2/ports.conf",
        require => Package["apache2"],
        notify => Service["apache2"],
        owner => "root",
        group => "root",
    }
}
