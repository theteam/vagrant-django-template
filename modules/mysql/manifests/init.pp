class mysql {

    $packages = ["mysql-server", "libmysqlclient16", "libmysqlclient-dev"]
    package { $packages: ensure => installed}

    file {"my.cnf":
        path => "/etc/mysql/my.cnf",
        source => "puppet:///modules/mysql/my.cnf",
        require => Package["mysql-server"],
        notify => Service["mysql"],
    }

    service { "mysql":
        ensure => running,
        enable => true,
        hasrestart => true,
        subscribe => [Package["mysql-server"],
                      File["my.cnf"]],
    }

    # First run? Set up the root user.
    exec { "set-mysql-root-password":
        unless => "mysqladmin -uroot -p$mysql_root_password status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $mysql_root_password",
        require => Package["mysql-server"],
    }
}

