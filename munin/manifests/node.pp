class munin::node::install {
    if $::operatingsystem != 'windows' {
        package { $munin::node::packagename:
            ensure => installed,
        }
        if $::lsbdistrelease == '12.04' { 
            package { 'libcache-cache-perl': 
                ensure => installed
            }
        }
    } else {
        file { 'C:\\munin-node-win32-v1.5.1942.msi':
            ensure => file,
            owner  => 'Administrateur',
            group  => 'Administrateurs',
            source => 'puppet:///modules/munin/munin-node-win32-v1.5.1942.msi'
        }
        package { 'Munin Node for Windows':
            ensure => installed,
            source => 'C:\\munin-node-win32-v1.5.1942.msi'
        }    
    } 
}

class munin::node::config {
    if $::operatingsystem != 'windows' {
        file { '/etc/munin/munin-node.conf':
            ensure  => file,
    	    replace => true,
            owner   => 'root',
	        group   => 'root',
            mode    => '0644',
            content => template('munin/munin-node.conf.erb'),
            require => Class['munin::node::install'],
            notify  => Class['munin::node::service'],  
        }   
        exec { 'munin-node-configure':
            path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
            command => 'eval $(munin-node-configure --shell)',
            creates => '/etc/munin/plugins/cpu',
        }
    }
}

class munin::node::service {
    service { $munin::node::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true
    }
}

class munin::node {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'munin-node',
        /(?i)(redhat|centos)/   => 'munin-node',
        /(?i)windows/           => 'munin-node',
        default                 => undef
    } $servicename = $packagename

    if $packagename != undef {
        if $::fqdn =~ /^exceptedhost(\d+)\.sub1\.domain\.tld$/ {
            notice("ExceptedHost $1")
        } else {
            @@file { 
                "/etc/munin/munin-conf.d/$::fqdn.conf": content => "[$::fqdn]\n\taddress $::ipaddress\n\tuse_node_name yes\n", tag => 'munin-node' 
            }
        }
        include munin::node::install, munin::node::config, munin::node::service
    }
}
