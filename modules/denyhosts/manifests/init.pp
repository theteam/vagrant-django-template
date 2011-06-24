class denyhosts {

    package { denyhosts: ensure => installed }

    service { denyhosts:
        ensure => running,
        enable => true
    }

    file {"/etc/denyhosts.conf":
        content => template("denyhosts/denyhosts.conf.erb"),
        require => Package["denyhosts"],
        notify => Service["denyhosts"]
    }
}
