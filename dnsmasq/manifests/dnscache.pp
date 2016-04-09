# It's crappy but...
#TODO:Deal w/ dns-nameservers & dns-search in /etc/network/interface

class dnsmasq::dnscache::config {
    file { '/etc/dnsmasq.d/dnscache':
        ensure  => file,
        replace => false, 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/dnsmasq/dnscache',
        require => Class["dnsmasq::install"],
    }
    ->
    file { '/etc/resolv.dnsmasq':
        ensure  => file,
        replace => true, 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('dnsmasq/resolv.conf.erb'),
        require => Class['dnsmasq::install'],
    }
    ->
    file { '/etc/resolv.conf.local':
        ensure  => file,
	    replace => true,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "search sub1.domain.tld sub2.domain.tld domain.tld\nnameserver 127.0.0.1\n"
    }
    ->
    exec { 'link-resolv.conf':
        command => 'mv /etc/resolv.conf /etc/resolv.conf.ori && ln -s /etc/resolv.conf.local /etc/resolv.conf',
        creates => '/etc/resolv.conf.ori',
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        onlyif  => 'test ! -h /etc/resolv.conf',
        unless  => 'test -h /etc/resolv.conf',
        notify  => Class['dnsmasq::service'],
    }
}

class dnsmasq::dnscache inherits dnsmasq {
    include dnsmasq::dnsmasq::config
}
