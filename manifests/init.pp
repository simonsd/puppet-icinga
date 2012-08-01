# Class: icinga
#
# Sample Usage:
#
#  # cat site.pp
#  Nagios_service {
#    host_name           => $::fqdn,
#    use                 => 'generic-service',
#    notification_period => '24x7',
#    target              => "${::icinga::targetdir}/services/${::fqdn}.cfg",
#    action_url          => '/pnp4nagios/graph?host=$HOSTNAME$&srv=$SERVICEDESC$',
#  }
#
#  Nagios_contact {
#    ensure                        => present,
#    use                           => 'generic-contact',
#    host_notification_period      => '24x7',
#    service_notification_period   => '24x7',
#    service_notification_commands => 'notify-service-by-email',
#    host_notification_commands    => 'notify-host-by-email',
#    target                        => "${::icinga::targetdir}/contacts/puppet-contacts.cfg",
#  }
#
#  # cat nodes.pp
#  node client {
#    class { 'icinga': }
#  }
#
#  node server {
#    class {
#      'icinga':
#        server        => 'true',
#        managerepo    => 'true',
#        icinga_admins => [ 'admin,', 'dummy1,', 'dummy2' ],
#        plugins       => [ 'checkpuppet', 'pnp4nagios' ];
#    }
#
#    icinga::user {
#      'dummy1':
#        ensure   => present,
#        password => 'default',
#        email    => 'dummy1@example.com',
#        pager    => '320000001';
#
#      'dummy2':
#        ensure   => present,
#        password => 'default'
#        email    => 'dummy2@example.com',
#        pager    => '320000002';
#    }
#  }
#
#  Inside your existing modules:
#    @@nagios_service { "check_tcp_123_${::fqdn}":
#      check_command       => 'check_tcp!123',
#      service_description => 'check_tcp',
#    }
#
#
# Known issues:
# Admin users listed in cgi.cfg will be removed after a second puppet run
# after the users have been removed from the htpasswd.users file. Once removed
# from htpasswd.users they won't be able to login anymore.
#
class icinga (
  $client                    = $::icinga::params::client,
  $client_group              = $::icinga::params::client_group,
  $client_user               = $::icinga::params::client_user,
  $use_auth                  = $::icinga::params::use_auth,
  $confdir_client            = $::icinga::params::confdir_client,
  $confdir_server            = $::icinga::params::confdir_server,
  $icinga_admins             = $::icinga::params::icinga_admins,
  $icinga_vhost              = $::icinga::params::icinga_vhost,
  $includedir_client         = $::icinga::params::includedir_client,
  $logdir_client             = $::icinga::params::logdir_client,
  $logdir_server             = $::icinga::params::logdir_server,
  $managerepo                = $::icinga::params::managerepo,
  $max_check_attempts        = $::icinga::params::max_check_attempts,
  $notification_period       = $::icinga::params::notification_period,
  $nrpe_allowed_hosts        = $::icinga::params::nrpe_allowed_hosts,
  $nrpe_server_address       = $::icinga::params::nrpe_server_address,
  $pidfile_client            = $::icinga::params::pidfile_client,
  $pidfile_server            = $::icinga::params::pidfile_server,
  $package_client            = $::icinga::params::package_client,
  $package_client_ensure     = $::icinga::params::package_client_ensure,
  $package_server            = $::icinga::params::package_server,
  $package_server_ensure     = $::icinga::params::package_server_ensure,
  $plugindir                 = $::icinga::params::plugindir,
  $plugins                   = $::icinga::params::plugins,
  $server                    = $::icinga::params::server,
  $server_cmd_group          = $::icinga::params::server_cmd_group,
  $server_group              = $::icinga::params::server_group,
  $server_user               = $::icinga::params::server_user,
  $service_client            = $::icinga::params::service_client,
  $service_client_enable     = $::icinga::params::service_client_enable,
  $service_client_hasrestart = $::icinga::params::service_client_hasrestart,
  $service_client_hasstatus  = $::icinga::params::service_client_hasstatus,
  $service_client_pattern    = $::icinga::params::service_client_pattern,
  $service_server            = $::icinga::params::service_server,
  $service_server_enable     = $::icinga::params::service_server_enable,
  $service_server_hasrestart = $::icinga::params::service_server_hasrestart,
  $service_server_hasstatus  = $::icinga::params::service_server_hasstatus,
  $service_webserver         = $::icinga::params::service_webserver,
  $sharedir_server           = $::icinga::params::sharedir_server,
  $targetdir                 = $::icinga::params::targetdir,
  $usrlib                    = $::icinga::params::usrlib,
  $vardir_client             = $::icinga::params::vardir_client,
  $vardir_server             = $::icinga::params::vardir_server,
  $webserver_group           = $::icinga::params::webserver_group,
  $webserver_user            = $::icinga::params::webserver_user
) inherits icinga::params {

  # motd::register { 'icinga-refactor': }

  include icinga::preinstall
  include icinga::install
  include icinga::config
  include icinga::plugins
  include icinga::collect
  include icinga::service

  Class['icinga::preinstall'] ->
  Class['icinga::install'] ->
  Class['icinga::config'] ->
  Class['icinga::plugins'] ->
  Class['icinga::collect'] ->
  Class['icinga::service']

  # Live fast, die young.
  case $::operatingsystem {
    # FIXME: debian is not fully tested yet, disabling for now
    #'Debian', 'Ubuntu': {}
    'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon': {}
    default: {
      fail "Operatingsystem ${::operatingsystem} is not supported."
    }
  }
}

