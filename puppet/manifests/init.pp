class puppet::install::gem {

    require rubygems
   
    package { ['facter']:
        ensure   => '1.7.2',
        provider => 'gem',
        require  => Package['rubygems1.8']
    }~>
    package { ['puppet']:
        ensure   => '2.7.11',
        provider => 'gem',
        require  => Package['rubygems1.8']
    } 

    file {'/etc/init.d/puppet':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
        source  => 'puppet:///modules/puppet/puppet.initd',
        notify  => Class["puppet::service"],
    }
}

class puppet::install {
    package { $puppet::packagename:
        ensure => latest,
        notify => Class["puppet::service"],
    }
}

class puppet::config {
    if $::operatingsystem != 'windows' {
        if $::fqdn == 'puppet.domain.tld' { 
            $type = 'srv' 
            $installClass = 'puppet::install'  
        } elsif $::operatingsystem == 'ubuntu' and $::lsbdistrelease <= '11.04' {
            $type = 'gem'
            $installClass = 'puppet::install::gem'  
        } else {
            $type = 'cli'
            $installClass = 'puppet::install'  
        }

        file {'/etc/puppet/puppet.conf':
            ensure  => file,
            replace => true,
            owner   => 'root',
            group   => 'puppet',
            mode    => '0640',
            source  => "puppet:///modules/puppet/puppet.conf-$type",
            require => Class["$installClass"],
            notify  => Class['puppet::service'],    
        }
        file {'/etc/default/puppet':
            ensure  => file,
            replace => true,
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            source  => 'puppet:///modules/puppet/puppet.default',
            require => Class["$installClass"],
            notify  => Class['puppet::service'],    
        }
    } #else {
        #exec { 'Path':
        #    command => 'C:\Windows\System32\cmd.exe /c setx path "%path%;C:\Program Files (x86)\Puppet Labs\Puppet\bin"',
        #}
    #}
}

class puppet::service {
    service { $puppet::servicename:
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => Class['puppet::config'],
    }
}

class puppet {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/ => 'puppet',
        /(?i)(redhat|centos)/ => 'puppet',
        /(?i)(windows)/       => 'puppet',
        default               => undef
    } $servicename = $packagename

    if $packagename != undef {
        
        if $::operatingsystem == 'ubuntu' and $::lsbdistrelease <= '11.04' {
                include puppet::install::gem, puppet::config, puppet::service
        } elsif $::operatingsystem == 'windows'{
            include puppet::config, puppet::service
        } else {
            include puppet::install, puppet::config, puppet::service
        }
    }
}
