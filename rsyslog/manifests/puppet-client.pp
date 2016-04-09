class rsyslog::puppet-client inherits rsyslog {
  file { '/etc/rsyslog.d/99-puppet-agent.conf':
    replace => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('rsyslog/client/puppet-agent.conf.erb'),
  }

  Package['rsyslog'] -> File['/etc/rsyslog.d/99-puppet-agent.conf'] ~> Service['rsyslog']
}
