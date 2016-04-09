class automysqlbackup::install {
    package { $automysqlbackup::packagename:
        ensure => purged,
    }
}

class automysqlbackup::config {
    file { '/etc/default/automysqlbackup':
        ensure   => file,
        replace  => false,
        owner    => 'root',
        group    => 'root',
        mode     => '0444',
        source   => 'puppet:///modules/automysqlbackup/automysqlbackup',
        require => Class["automysqlbackup::install"],
    }
}

class automysqlbackup {
    $packagename = $::operatingsystem ? {
	    /(?i)(ubuntu|debian)/ 	=> 'automysqlbackup',
        default                 => undef
    }

    if $packagename != undef {
        include automysqlbackup::install, automysqlbackup::config
    }
}
