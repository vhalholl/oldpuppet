class vim::install {
    package { $vim::packagename:
        ensure => installed,
    }
}

class vim::config {
    file { '/root/.vim':
        ensure  => directory,
        replace => false, 
	    recurse => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/vim/.vim",
        require => Class["vim::install"],
    }
}

class vim {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'vim',
        /(?i)(redhat|centos)/   => 'vim-enhanced',
        default                 => undef
    }

    if $packagename != undef {
        include vim::install, vim::config
    }
}
