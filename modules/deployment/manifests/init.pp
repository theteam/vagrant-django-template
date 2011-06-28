class deployment {

    $deploy_user = "deployer"
    $deploy_group = "www-data"
    
    user {$deploy_user:
        name       => $deploy_user,
        gid        =>  $deploy_group,
        home       => "/home/$deploy_user",
        shell      => "/bin/bash",
        managehome => true,
        ensure     => "present",
    }

    file {"/home/$deploy_user/.ssh":
        ensure  => directory,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 700,
        require => User[$deploy_user],
    }

    file {"/home/$deploy_user/.ssh/authorized_keys":
        ensure => present,
        owner  => $deploy_user,
        group  => $deploy_group,
        mode   => 640,
        source => "puppet:///modules/deployment/ssh/authorized_keys",
    }

    file {"/home/$deploy_user/.ssh/id_rsa":
        ensure => present,
        owner  => $deploy_user,
        group  => $deploy_group,
        mode   => 640,
        source => "puppet:///modules/deployment/ssh/id_rsa",
    }

    file {"/home/$deploy_user/.ssh/id_rsa.pub":
        ensure => present,
        owner  => $deploy_user,
        group  => $deploy_group,
        mode   => 640,
        source => "puppet:///modules/deployment/ssh/id_rsa.pub",
    }

}
