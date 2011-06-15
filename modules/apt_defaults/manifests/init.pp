class apt_defaults {
      exec { "apt-update":
        command     => "/usr/bin/apt-get update",
        refreshonly => true;
      }
      cron { "apt-update":
        command => "/usr/bin/apt-get update",
        user    => root,
        hour    => 22,
        minute  => 0;
      }
}