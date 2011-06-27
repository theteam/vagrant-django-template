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

  exec { "easy_install pip":
      path => "/usr/local/bin:/usr/bin:/bin",
      refreshonly => true,
      require => Package["python-setuptools"],
      subscribe => Package["python-setuptools"],
  }
}
