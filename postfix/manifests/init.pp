## Postfix
class postfix::install {
    package { $postfix::packagename:
        ensure => installed,
    }
}

class postfix::config {
    file { '/etc/postfix/main.cf':
        ensure  => file,
    	replace => false,
        owner   => 'root',
	    group   => 'root',
        mode    => '0644',
        content => template('postfix/main.cf.erb'),
        require => Class['postfix::install'],
        notify  => Class['postfix::aliases'],  
    }   
}

class postfix::aliases {
    # Only For Reconfiguration ! TODO: make template aliases.erb w/ replace => false
    exec { 'service-root aliases':
        require => Class['postfix::config'],
        notify  => Class['postfix::service'],  
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        command => "echo 'root: service-root@domain.tld' >> /etc/aliases && newaliases",
        onlyif  => [
            'test -f /etc/aliases',
            "test ! $(grep 'root:' /etc/aliases)",
            "test ! $(grep 'service-root' /etc/aliases)"
        ]
    }
    
    case $::fqdn {
        'www.domain.tld:',
        'www-sql.sub1.domain.tld',
        'www-sql.sub2.domain.tld',
        'www-gfs.sub1.pj.domain.tld',
        'www-gfs.sub2.domain.tld', 
        'redmine.domain.tld' : {
            exec { 'Webmaster aliases':
                require => Class['postfix::config'],
                notify  => Class['postfix::service'],  
                path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
                command => "sed -i 's/service-root@domain.tld/dosi-root@domain.tld, webmaster@domain.tld/' /etc/aliases && newaliases",
                onlyif  => [
                    "test ! $(grep 'webmaster@domain.tld' /etc/aliases)",
                ]
            }
        }
    }
}

class postfix::service {
    service { $postfix::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class['postfix::aliases'],
    }
}

class postfix {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'postfix',
        /(?i)(redhat|centos)/   => 'postfix',
        default                => undef
    } $servicename = $packagename

    if $packagename != undef {
        case $::hostname {
            'bv-webdav':                            { $service = undef }
            'bureau-test', /^bureau-frontal(\d+)$/: { $service = undef }
            default:            { include postfix::install, postfix::config, postfix::aliases, postfix::service }
        }
    }
}
