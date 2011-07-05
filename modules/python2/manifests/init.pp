class python2 {
    $packages = [
            "build-essential", 
            "python", 
            "python-dev", 
            "python-setuptools",
            "python-mysqldb",
            "python-imaging",
            "python-memcache",
            "python-virtualenv"
    ]

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
}
