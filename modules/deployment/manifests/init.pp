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

    file {"ssh-directory":
        path    => "/home/$deploy_user/.ssh",
        ensure  => directory,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 755,
        require => User[$deploy_user],
    }

    file {"ssh-authorized-keys":
        path    => "/home/$deploy_user/.ssh/authorized_keys",
        ensure  => present,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 644,
        source  => "puppet:///modules/deployment/ssh/authorized_keys",
        require => File["ssh-directory"],
    }

    file {"ssh-known-hosts":
        path    => "/home/$deploy_user/.ssh/known_hosts",
        ensure  => present,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 644,
        source  => "puppet:///modules/deployment/ssh/known_hosts",
        require => File["ssh-directory"],
    }

    file {"ssh-private-key":
        path    => "/home/$deploy_user/.ssh/id_rsa",
        ensure  => present,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 600,
        source  => "puppet:///modules/deployment/ssh/id_rsa",
        require => File["ssh-directory"],
    }

    file {"ssh-public-key":
        path    => "/home/$deploy_user/.ssh/id_rsa.pub",
        ensure  => present,
        owner   => $deploy_user,
        group   => $deploy_group,
        mode    => 644,
        source  => "puppet:///modules/deployment/ssh/id_rsa.pub",
        require => File["ssh-directory"],
    }

}
