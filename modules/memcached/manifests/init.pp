class memcached {

    package { memcached: ensure => installed }

    service { memcached:
        ensure => running,
        enable => true
    }

    file {"/etc/memcached.conf":
        content => template("memcached/memcached.conf.erb"),
        require => Package["memcached"],
        notify => Service["memcached"]
    }
}
