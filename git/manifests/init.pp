class git::install {
    package { $git::packagename:
        ensure => latest,
    }
}

class git::config {
    file { '/root/.gitconfig':
        ensure  => file,
        replace => false, 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('git/gitconfig.erb'),
        require => Class["git::install"],
        #source  => "puppet:///modules/git/.gitconfig",
    }
    exec { 'ssh-keygen':
        command => "ssh-keygen -f /root/.ssh/$::hostname -C '$::hostname' -t rsa -b 2048 -P '' -q",
        creates => "/root/.ssh/$::hostname",
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        onlyif  => "test ! -f /root/.ssh/$::hostname",
        unless  => "test -f /root/.ssh/$::hostname"
    }
    exec { 'ssh-config':
        command => "echo \"IdentitiesOnly yes\\nHost redmine\\n\\tHostname redmine.domain.tld\\n\\tUser sysgitadmin\\n\\tIdentityFile ~/.ssh/$::hostname\">> /root/.ssh/config",
        creates => "/root/.ssh/config",
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        unless  => 'grep "Host rubis" /root/.ssh/config'
    }
}

class git {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'git',
        /(?i)(redhat|centos)/   => 'git',
        default                 => undef
    }

    if $packagename != undef {
        include git::install, git::config
    }
}
