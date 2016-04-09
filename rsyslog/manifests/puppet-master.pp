class rsyslog::puppet-master inherits rsyslog {
  file { '/etc/rsyslog.d/99-puppet-master.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('puppet_rsyslog/client/puppet-master.conf'),
  }

  Package['rsyslog'] -> File['/etc/rsyslog.d/99-puppet-master.conf'] ~> Service['rsyslog']
}
