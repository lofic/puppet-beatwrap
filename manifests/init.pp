# Custom deployment of filebeat and other elastics beats.

class beatwrap(String $elsrv) {

    contain elastic_stack::repo

    package { 'filebeat': ensure => present }

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['filebeat'],
        notify  => Service['filebeat'],
    }

    file { '/etc/filebeat/filebeat.yml':
        content => template('beatwrap/filebeat.yml.erb'),
    }

    file { '/etc/filebeat/modules.d/system.yml':
        content => template('beatwrap/modules.d/system.yml.erb'),
        mode    => '0644',
    }

    service { 'filebeat':
        ensure => 'running',
        enable => true,
    }

}
