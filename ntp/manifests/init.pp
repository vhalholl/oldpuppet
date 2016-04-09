class ntp::install {
    package { $ntp::packagename:
        ensure => installed,
    }
}

class ntp::config {
    #file { '/etc/ntp.conf':
    #    ensure   => file,
    #    replace  => true,
    #    owner    => 'root',
    #    group    => 'root',
    #    mode     => '0444',
    #    source   => 'puppet:///modules/ntp/ntp.conf',
    #    require => Class["ntp::install"],
    #    notify  => Class["ntp::service"],    
    #}
}

class ntp::service {
    if $::fqdn != 'exceptedhost.domain.tld' {
        service { $ntp::servicename:
            ensure => stopped,
            enable => false,
        }
    } else {
        service { $ntp::servicename:
            ensure     => running,
            hasstatus  => true,
            hasrestart => true,
            enable     => true,
            require    => Class["ntp::config"],
        }
    }
}

class ntp {
    $packagename = $::operatingsystem ? {
	    /(?i)(ubuntu|debian)/ 	=> 'openntpd',
	    /(?i)(redhat|centos)/ 	=> 'ntp.x86_64',
        default                 => undef
    } $servicename = $packagename

    if $packagename != undef {
        if $::is_virtual != 'true' {
            include ntp::install, ntp::config, ntp::service
        }
    }
}
