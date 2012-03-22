# Only works for debian ATM

class monit {
	$configdir = "/etc/monit/conf.d"
	$config = "/etc/monit/monitrc"

	$monitrc = "monit/monitrc.erb"

	package {
		"monit": ensure => installed,
	}

	service { "monit":
		enable => true,
		ensure => running,
		hasrestart => true,
		hasstatus => false,
		require => Package["monit"],
		pattern => "/usr/sbin/monit",
	}

	exec { "reload":
		command => "/usr/sbin/monit reload",
		refreshonly => true,
	}

	File {
		notify => Exec["reload"],
		require => Package["monit"],
	}

	file {"/etc/default/monit":
		ensure => present,
		source => "puppet:///modules/monit/monit",
		before => Service["monit"],
		owner => root,
		group => root,
		mode => 644,
	}

	file {"/etc/monit/conf.d/ssh":
		ensure => present,
		source => "puppet:///modules/monit/ssh",
		before => Service["monit"],
		owner => root,
		group => root,
		mode => 644,
	}
}
