class dnsmasq::install {
    package { $dnsmasq::packagename:
        ensure => installed,
    }
}

class dnsmasq::config {
    file { '/etc/dnsmasq.conf':
        ensure  => file,
        replace => false, 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/dnsmasq/dnsmasq.conf',
        require => Class['dnsmasq::install'],
    }
}

class dnsmasq::service {
    service { $dnsmasq::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class["dnsmasq::config"],
    }
}

class dnsmasq {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'dnsmasq',
        #    /(?i)(redhat|centos)/   => 'dnsmasq',
        default                 => undef
    } $servicename = $packagename

    if $packagename != undef {
        include dnsmasq::install, dnsmasq::config, dnsmasq::service
    }
}
