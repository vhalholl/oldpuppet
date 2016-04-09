class munin::install {
    package { $munin::packagename:
        ensure => installed,
    }
}

class munin::service {
    service { $munin::servicename:
        #ensure     => running,
        #hasstatus  => true,
        hasrestart => true,
        enable     => true
    }
}

class munin {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'munin',
        /(?i)(redhat|centos)/   => 'munin',
        default                 => undef
    } $servicename = $packagename

    File <<| tag == 'munin-node' |>>

    if $packagename != undef {
        include munin::install, munin::service
    }
}
