define deployment::production::setup ($project_path="",
                                       $src_path="",
                                       $owner="deployer",
                                       $group="www-data") {

    $project_name = $name
    
    exec { "source-checkout":
        unless  => "test -d $src_path",
        path   => "/usr/local/bin:/usr/bin:/bin",
        user => "deployer",
        group => $group,
        command => "git clone -b master $git_checkout_url $src_path",
        require => [
                    Package["git-core"],
                    File["ssh-known-hosts"],
                    File["ssh-public-key"],
                    File["ssh-private-key"],
                    File[$project_path],
                   ],
    }

}
