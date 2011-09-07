define djangoapp::development::setup ($project_path="",
                                      $src_path="",
                                      $owner="deployer",
                                      $group="www-data") {

    $project_name = $name

    # We don't check out the code to the src directory, 
    # instead Vagrant mounts the project folder from the 
    # host machine at this location (on our guest vm)
    # and therefore the symlink will link this all up.
    

    file { "${project_path}current":
        path    => "${project_path}current",
        ensure  => link,
        target  => $src_path,
        owner   => $owner,
        group   =>  $group,
    }
}
