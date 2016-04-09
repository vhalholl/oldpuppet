class motd {
    if $::operatingsystem == 'ubuntu' {  
        file { '/etc/update-motd.d/':
            ensure  => directory,
            replace => true,
            recurse => true,
            owner   => 'root',
            group   => 'root',
            mode    => '0750',    
            source  => "puppet:///modules/motd/update-motd.d"
        }
    }
}
