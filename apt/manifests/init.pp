class apt::install {
    package { $apt::packagename:
        ensure => installed,
    }
}

class apt::ubuntu {
    if $::lsbdistrelease >= '11.10' { 
        file { '/etc/apt/sources.list':
            ensure  => file,
            replace => false,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',    
            source  => 'puppet:///modules/apt/sources.list.ubuntu', 
            require => Class['apt::install'],
        }
        
        file { '/etc/apt/sources.list.d/main.sources.list':
            ensure  => file,
            replace => false,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',    
            content => template('apt/ubuntu/main.sources.list.erb'), 
        }

        file { '/etc/apt/sources.list.d/security.sources.list':
            ensure  => file,
            replace => false,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',    
            content => template('apt/ubuntu/security.sources.list.erb'), 
        }

        file { '/etc/apt/sources.list.d/backports.sources.list':
            ensure  => file,
            replace => false,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',    
            content => template('apt/ubuntu/backports.sources.list.erb'), 
        }
    }
}

class apt::debian {
    file { '/etc/apt/sources.list':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/apt/sources.list.debian', 
        require => Class['apt::install'],
    }

    file { '/etc/apt/sources.list.d/main.sources.list':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        content => template('apt/debian/main.sources.list.erb'), 
    }

    file { '/etc/apt/sources.list.d/security.sources.list':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        content => template('apt/debian/security.sources.list.erb'), 
    }
}

class apt::proxy {
    case $::ipaddress_eth0 {
        /^10\.193\.[\d]\.[\d]+$/: {
            file { '/etc/apt/apt.conf.d/99proxy':
                ensure  => file,
                replace => true,
                owner   => 'root',
                group   => 'root',
                mode    => '0640',
                content => template('apt/99proxy.erb'),
                #source  => "puppet:///modules/apt/proxy.conf",
            }
        }
    }
}

class apt::config {
    case $::operatingsystem {
        'Debian': { include apt::debian, apt::proxy }
        'Ubuntu': { include apt::ubuntu, apt::proxy }
    }
    # Ugly and useless, but i need this for the moment
    cron {'killzombiesprocess':
        name    => 'Kill Zombies Process',
        ensure  => absent,
        #command => "kill -9 $(ps aux |grep 'Zs' |grep -v grep |awk '{print \$2}' |xargs) &>/dev/null",
        command => "kill -9 $(ps -A -ostat,ppid |grep -e '^[Zz]' |awk '{print \$2}' |xargs) &>/dev/null",
        user    => root,
        hour    => '*/1'
    }
}

class apt {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'apt',
        default                 => undef
    } 

    if $packagename != undef {
        include apt::install, apt::config
    }
}
