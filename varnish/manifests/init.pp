class varnish::install {
    package { $varnish::packagename:
        ensure => installed,
    }
}

class varnish::config {
    file { '/etc/default/varnish':
        ensure  => file,
    	replace => true,
        owner   => 'root',
	    group   => 'root',
        mode    => '0644',
        content => template('varnish/varnishdefault.erb'),
        require => Class['varnish::install'],
        notify  => Class['varnish::service'],  
    }   
}

class varnish::service {
    service { $varnish::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class["varnish::config"],
    }
}

class varnish {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'varnish',
        /(?i)(redhat|centos)/   => 'varnish',
        default                 => undef
    } $servicename = $packagename

    if $packagename != undef {
            include varnish::install, varnish::config, varnish::service
    }
}
