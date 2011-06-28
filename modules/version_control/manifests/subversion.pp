class version_control::subversion {

    package { "subversion": 
               ensure => installed,
               require => Exec["aptitude-update"]}

}
