class logrotate {

    package { logrotate: ensure => installed }

    file {"/etc/logrotate.conf":
        source => "puppet:///modules/logrotate/logrotate.conf",
        require => Package["logrotate"],
    }
}
