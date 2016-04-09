class yum::install {
    package { $yum::packagename:
        ensure => installed,
    }
}

class yum::proxy {
    case $::ipaddress_eth0 {
        /^10\.193\.[\d]\.[\d]+$/: {
            file { '/etc/yum.conf':
                ensure  => file,
                replace => true,
                owner   => 'root',
                group   => 'root',
                mode    => '0640',    
                #source  => 'puppet:///modules/yum/yum.conf', 
                content => template('yum/yum.conf.erb'),
            }
            file { '/etc/sysconfig/rhn/up2date':
                ensure  => file,
                replace => true,
                owner   => 'root',
                group   => 'root',
                mode    => '0640',
                #source  => 'puppet:///modules/yum/up2date',    
                content => template('yum/up2date.erb'),
            }
        }
    }
}

class yum {
    $packagename = $::operatingsystem ? {
        /(?i)(redhat|centos)/   => 'yum',
        default                 => undef
    } 

    if $packagename != undef {
        include yum::install, yum::proxy
    }
}
