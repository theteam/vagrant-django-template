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
    exec { "set-mysql-password":
        unless => "mysqladmin -uroot -p$mysql_root_password status",
        path => ["/bin", "/usr/bin"],
        command => "mysqladmin -uroot password $mysql_root_password",
        require => Service["mysql"],
    }
}

define mysql::createdb($db_name, $db_user, $db_password) {
    exec { "create-$db_name-db":
        unless => "/usr/bin/mysql -u$db_user -p$db_password $db_name",
        command => "/usr/bin/mysql -uroot -p$mysql_root_password -e 'CREATE DATABASE `$db_name`; CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_password'; GRANT USAGE ON * . * TO '$db_user'@'localhost' IDENTIFIED BY '$db_password' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT ALL PRIVILEGES ON `$db_name` . * TO '$db_user'@'localhost'; FLUSH PRIVILEGES;",
        require => Service["mysql"],
    }
}

