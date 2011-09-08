define djangoapp::production::setup ($project_path="",
                                     $src_path="",
                                     $owner="deployer",
                                     $group="www-data") {

    $project_name = $name
    
    exec { "source-checkout":
        unless  => "test -d $src_path",
        path    => "/usr/local/bin:/usr/bin:/bin",
        user    => $owner,
        group   => $group,
        command => "git clone -b master ${djangoapp::git_checkout_url} ${src_path}",
        require => [
                    Package["git-core"],
                    File["ssh-known-hosts"],
                    File["ssh-public-key"],
                    File["ssh-private-key"],
                    File[$project_path],
                   ],
    }

    file { "${project_path}current":
        path    => "${project_path}current",
        ensure  => directory,
        mode    => 775,
        require => Exec["source-checkout"],
        owner   => $owner,
        group   =>  $group,
    }
}
