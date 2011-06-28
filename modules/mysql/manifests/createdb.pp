define mysql::createdb($db_name, $db_user, $db_pass) {
    exec { "create-$db_name-db":
        # Only do this if the database doesn't already exist!
        unless => "/usr/bin/mysql -uroot -p$mysql_root_password $db_name",
        command => "/usr/bin/mysql -uroot -p$mysql_root_password -e \"CREATE DATABASE \\`$db_name\\`; CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass'; GRANT USAGE ON * . * TO '$db_user'@'localhost' IDENTIFIED BY '$db_pass' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT ALL PRIVILEGES ON \\`$db_name\\` . * TO '$db_user'@'localhost'; FLUSH PRIVILEGES;\"",
        require => Exec["set-mysql-root-password"],
    }
}
