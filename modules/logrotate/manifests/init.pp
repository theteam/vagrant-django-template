class logrotate {

    package { logrotate: ensure => installed }

    file {"/etc/logrotate.conf":
        content => template("logrotate/logrotate.conf.erb"),
        require => Package["logrotate"],
    }
}
