class bash::install {
    package { $bash::packagename:
        ensure => installed,
    }
}

class bash::config {
     file { '/root/.bashrc':
        ensure  => file,
        replace => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bashrc', 
        require => Class['bash::install'],
    }  

    file { '/root/.bash_aliases':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_aliases', 
    }

    file { '/root/.bash_functions':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_functions', 
    }
    
    file { '/root/.bash_functions_file':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_functions_file', 
    }

     file { '/root/.bash_functions_mgmt':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_functions_mgmt', 
    }   
    
    file { '/root/.bash_functions_netw':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_functions_netw', 
    }

    file { '/root/.bash_functions_misc':
        ensure  => file,
        replace => false,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',    
        source  => 'puppet:///modules/bash/.bash_functions_misc', 
    }
}

class bash {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'bash',
        default                 => undef
    }

    if $packagename != undef {
        include bash::install, bash::config
    }
}
