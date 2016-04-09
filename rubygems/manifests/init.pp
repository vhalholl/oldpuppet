class rubygems::install {
    package { $rubygems::packagename:
        ensure => latest,
    }   
}

class rubygems::config {
    case $::ipaddress {
        /^10\.193\.1\.[\d]+$/: {
            file {'/root/.gemrc':
                ensure  => file,
                replace => true,
                owner   => 'root',
                group   => 'root',
                mode    => '0640',
                content => "http_proxy: http://${httpProxyAddress}:$httpProxyPort",
                require => Class["rubygems::install"],
            }
        }
    }
}

class rubygems {
    $packagename = $::operatingsystem ? {
        /(?i)(ubuntu|debian)/   => 'rubygems1.8',
        /(?i)(redhat|centos)/   => 'rubygems1.8',
        default                  => undef
    }

    if $packagename != undef {
        include rubygems::install, rubygems::config
    }
}
