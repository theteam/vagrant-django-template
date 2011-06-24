class iptables {

    package { iptables: ensure => installed }

    file {"iptables.rules":
        path => "/etc/iptables.rules",
        source => "puppet:///modules/iptables/iptables.rules",
        require => Package["iptables"],
    }
}
