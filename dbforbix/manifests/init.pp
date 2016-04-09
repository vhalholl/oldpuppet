class dbforbix::install {
    file { '/opt/dbforbix/':
        ensure  => directory,
        replace => false,
        recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/dbforbix/dbforbix",
    }
    ->
    file { '/lib/ojdbc6.jar/':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/dbforbix/ojdbc6.jar",
        notify  => Class["dbforbix::config"],
    }
}

class dbforbix::config {
    file { '/opt/dbforbix/conf/config.props':
        ensure  => file,
        replace => false, 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('dbforbix/config.props.erb'),
        require => Class["dbforbix::install"],
    }
    ->
    exec { 'link-init.d':
        command => 'ln -s /opt/dbforbix/init.d/dbforbix /etc/init.d/',
        creates => '/etc/init.d/dbforbix',
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        onlyif  => 'test ! -h /etc/init.d/dbforbix',
        unless  => 'test -h /etc/init.d/dbforbix',
        notify  => Class["dbforbix::service"],
    }
#    ->
#    exec { 'chkconfig':
#        command => 'chkconfig -add dbforbix',
#        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
#        unless  => 'chkconfig --list |grep dbforbix',
#    }
}

class dbforbix::service {
    service { $dbforbix::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class["dbforbix::config"],
    }
}

class dbforbix {
    $packagename = $::operatingsystem ? {
#        /(?i)(ubuntu|debian)/        => 'dbforbix',
        /(?i)(redhat|centos|fedora)/ => 'dbforbix',
        default                      => undef
    } $servicename = $packagename

    if $packagename != undef {
        include dbforbix::install, dbforbix::config, dbforbix::service
    }
}
