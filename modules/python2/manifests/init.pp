class python2 {
    $packages = ["build-essential", 
               "python", 
               "python-dev", 
               "python-setuptools",
               "python-mysqldb",
               "python-imaging",
               "python-memcache"]

    package {
        $packages: ensure => installed;
    }

    exec { "install-pip":
        path        => "/usr/local/bin:/usr/bin:/bin",
        refreshonly => true,
        command     => "easy_install pip",
        require     => Package["python-setuptools"],
        subscribe   => Package["python-setuptools"],
    }

    exec { "install-virtualenv":
        path        => "/usr/local/bin:/usr/bin:/bin",
        refreshonly => true,
        command     => "pip install virtualenv",
        require     => Exec["install-pip"],
    }
}
