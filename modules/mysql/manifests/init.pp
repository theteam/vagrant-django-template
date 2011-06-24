class mysql {

    package { "mysql-server": ensure => installed}
    package { "libmysqlclient16": ensure => installed}
    package { "libmysqlclient-dev": ensure => installed}

    service { "mysqld":
        ensure => running,
        enable => true,
        require => Package["mysql-server"],
    }

    file {"/etc/mysql/my.cnf":
        content => template("mysql/my.cnf.erb"),
        require => Package["mysql-server"],
        notify => Service["mysqld"],
    }

    # First run? Set up the root user.
    exec { "set-mysql-password":
        unless => "mysqladmin -uroot -p$mysql_root_password status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $mysql_root_password",
        require => Service["mysqld"],
    }

    # First run? Set up the project database.
    exec { "set-mysql-password":
        unless => "mysqladmin -uroot -p$mysql_root_password status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $mysql_root_password",
        require => Service["mysqld"],
    }
}
