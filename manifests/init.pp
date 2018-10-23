# Custom deployment of filebeat and other elastic beats.

class beatwrap(String $elsrv) {

    include elastic_stack::repo

    package { 'filebeat':
        ensure  => present,
        require => Class['elastic_stack::repo'],
    }

    $filedefaults = {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Package['filebeat'],
        notify  => Service['filebeat'],
    }

    file {
        default: * => $filedefaults;

        '/etc/filebeat/filebeat.yml':
            content => template('beatwrap/filebeat.yml.erb');

        '/etc/filebeat/modules.d/system.yml':
            content => template('beatwrap/modules.d/system.yml.erb'),
            mode    => '0644';
    }

    service { 'filebeat':
        ensure => 'running',
        enable => true,
    }

}
