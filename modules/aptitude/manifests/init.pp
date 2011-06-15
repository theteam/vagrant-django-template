class aptitude {
      exec { "aptitude":
        command     => "/usr/bin/aptitude update",
        refreshonly => true;
      }
      cron { "aptitude":
        command => "/usr/bin/aptitude update",
        user    => root,
        hour    => 23,
        minute  => 59;
      }
}