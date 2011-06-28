class sshd {

    package { "openssh-server": 
        ensure => installed,
    }

}
