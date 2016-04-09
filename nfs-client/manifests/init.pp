class nfs-client::install {
    package { $nfs-client::packagename:
        ensure => installed,
    }
}

class nfs-client::zabbix-stats {
    file {"/root/scripts":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0750'
    }

    file {"/root/scripts/znfs.pl":
        ensure  => file,
        replace => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        content => template("nfs-client/znfs.pl.erb"),
        require => Class["nfs-client::install"]
    }

    cron { zabbix-stats:
        ensure  => present,
        command => "/root/scripts/znfs.pl >/dev/null",
        user    => root,
        minute  => '*/10'
    }
}

class nfs-client {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'nfs-common',
        /(?i)(redhat|centos)/   => 'nfs-common',
        default                 => undef
    }

    if $packagename != undef {
        include nfs-client::install, nfs-client::zabbix-stats
    }
}
