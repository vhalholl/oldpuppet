class rsyslog::install {
    package { $rsyslog::packagename:
        ensure => installed,
    }
}

class rsyslog::service {
    service { $rsyslog::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true
    }
}

class rsyslog {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'rsyslog',
        default                 => undef
    } $servicename = $packagename

    if $packagename != undef {
        include rsyslog::install, rsyslog::service
    }
}
