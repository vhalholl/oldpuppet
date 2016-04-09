class ssh::install {
    package { $ssh::packagename:
        ensure => installed,
    }
}

class ssh::authkeys {
    file { '/root/.ssh/authorized_keys':
        ensure   => file,
        replace  => false,
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        content => template("ssh/authorized_keys.erb"),
        require => Class["ssh::install"],
        notify  => Class["ssh::service"],    
    }
}

class ssh::service {
    service { $ssh::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class["ssh::authkeys"],
    }
}

class ssh {
    $packagename = $::operatingsystem ? {
	    /(?i)(ubuntu|debian)/ 	=> 'openssh-server',
	    /(?i)(redhat|centos)/ 	=> 'openssh',
        default                 => undef
    } 

    $servicename = $::operatingsystem ? {
	    /(?i)(ubuntu|debian)/ 	=> 'ssh',
	    /(?i)(redhat|centos)/ 	=> 'sshd',
        default                 => undef
    } 

    if $packagename != undef {
        include ssh::install, ssh::authkeys, ssh::service
    }
}
