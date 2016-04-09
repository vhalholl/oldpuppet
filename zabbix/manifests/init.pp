class zabbix::install {
    if $::operatingsystem != 'windows' {
        package { $zabbix::packagename:
            ensure => installed,
        }
    }
}

class zabbix::config {
    if $::operatingsystem != 'windows' {
        file { '/etc/zabbix/zabbix_agentd.conf':
            ensure  => file,
            replace => true,
            owner   => 'zabbix',
            group   => 'zabbix',
            mode    => '0640',    
            source  => 'puppet:///modules/zabbix/zabbix_agentd.conf' 
        }
        file { '/etc/zabbix/zabbix_agentd.conf.d':
            ensure  => directory,
            replace => true, 
            recurse => true,
            owner   => 'zabbix',
            group   => 'zabbix',
            # puppet will automatically set +x for directories
            mode    => '0640',
            source  => 'puppet:///modules/zabbix/zabbix_agentd.conf.d'
        }
        file {'/etc/zabbix/zabbix_agentd.conf.d/domain':
            ensure  => file,
            owner   => 'zabbix',
            group   => 'zabbix',
            mode    => '0640',
            content => template('zabbix/domain.erb'),
            require => Class['zabbix::install'],
            notify  => Class['zabbix::service'],    
        }
 
        if $::operatingsystem == 'ubuntu' and $::lsbdistrelease != '12.04' {
            exec {'sed /etc/init.d/zabbix-agent':
                path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
                command => 'sed -i "s/DIR=\/var\/run\/zabbix-agent/DIR=\/var\/run\/zabbix/" /etc/init.d/zabbix-agent && rm -rf /var/run/zabbix-agent',
                onlyif  => [
                    'grep "DIR=/var/run/zabbix-agent" /etc/init.d/zabbix-agent',
                    'test -d /var/run/zabbix-agent'
                ]
            }
            file {"/var/run/zabbix":
                ensure => directory,
                owner  => 'zabbix',
                group  => 'zabbix',
                mode   => '0640',
                notify  => Class['zabbix::service'], 
            }
        }
        
        exec {'change /etc/mysql/debian.cnf':
            path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
            command => 'chown root:zabbix /etc/mysql/debian.cnf && chmod 640 /etc/mysql/debian.cnf',
            onlyif  => 'test -e /etc/mysql/debian.cnf',
            unless  => 'ls -l /etc/mysql/debian.cnf |grep "zabbix"',
            notify  => Class['zabbix::service']
        }

    } else {
        $dir = $::architecture ? { 
            'x64' => 'win64', 
            'x86' => 'win32', 
        }
        file {'C:/Program Files/Zabbix':
            ensure  => directory,
            replace => false,
            recurse => true,
            source  => "puppet:///modules/zabbix/$dir",
        }
        file { 'C:/Program Files/Zabbix/zabbix_agentd.conf':
            ensure  => file,
            replace => true,
            mode    => '660',
            owner   => 'Administrateur',
            group   => 'Administrateurs',
            content => template('zabbix/win.erb'),
        }
        exec { 'Install Zabbix':
            path    => 'C:\Windows\System32',
            command => '"C:\Program Files\Zabbix\zabbix_agentd.exe" --config "C:\Program Files\Zabbix\zabbix_agentd.conf" --install',
            unless  => 'sc.exe query "ZABBIX Agent"',
        }
        exec { 'TCP Port 10050':
            command => 'C:/Windows/System32/netsh.exe advfirewall firewall add rule name="Zabbix: Allow TCP 10050" dir=in action=allow protocol=tcp localport=10050',
            unless => 'C:/Windows/system32/netsh.exe advfirewall firewall show rule name="Zabbix: Allow TCP 10050"',
            notify  => Class["zabbix::service"]
        }
    }
}

class zabbix::service {
        #if $::operatingsystem != 'windows' {
        service { $zabbix::servicename:
            ensure     => running,
            hasstatus  => true,
            hasrestart => true,
            enable     => true,
            require    => Class['zabbix::config'],
        }
        #} else {
        #    service { $zabbix::servicename:
        #        path     => 'C:\Windows\System32',
        #        #provider => 'windows',
        #        ensure   => running,
        #        enable   => true,
        #        require  => Class['zabbix::config'],
        #    }
        #}
}

class zabbix {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/ => 'zabbix-agent',
        /(?i)windows/         => 'ZABBIX Agent',
        default               => undef
    } $servicename = $packagename

    if $packagename != undef {
        include zabbix::install, zabbix::config, zabbix::service
    }
}
