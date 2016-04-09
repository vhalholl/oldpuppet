class rsyslog::server inherits rsyslog {
    #  file { '/etc/rsyslog.d/udp.conf':
    #    replace => false,
    #    owner   => 'root',
    #    group   => 'root',
    #    mode    => 0640,
    #    source  => 'puppet:///rsyslog/server/udp.conf',
    #  }
    
  file { '/etc/rsyslog.d/99-puppet-master.conf':
      replace => true,
      owner   => 'root',
      group   => 'root',
      mode    => 0640,
      source  => 'puppet:///rsyslog/server/puppet-master.conf',
  }

  file { '/etc/rsyslog.d/99-puppet-client.conf':
      replace => true,
      owner   => 'root',
      group   => 'root',
      mode    => 0640,
      source  => 'puppet:///rsyslog/server/puppet-client.conf',
  }

  file { '/etc/default/rsyslog':
      replace => false,
      owner   => 'root',
      group   => 'root',
      mode    => 0640,
      source  => 'puppet:///rsyslog/server/default_rsyslog',
  }

  #Package['rsyslog'] -> File['/etc/rsyslog.d/udp.conf'] ~> Service['rsyslog']
  Package['rsyslog'] -> File['/etc/rsyslog.d/99-puppet-master.conf'] ~> Service['rsyslog']
  Package['rsyslog'] -> File['/etc/rsyslog.d/99-puppet-client.conf'] ~> Service['rsyslog']
  Package['rsyslog'] -> File['/etc/default/rsyslog'] ~> Service['rsyslog']
}
