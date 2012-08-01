class icinga::plugins::pnp4nagios (
  $ensure  = present,
  $libexec = '/usr/libexec/pnp4nagios'
) {
  if $icinga::server {
    include icinga::plugins::pnp4nagios::install
    include icinga::plugins::pnp4nagios::config

    Class['icinga::plugins::pnp4nagios::install'] -> Class['icinga::plugins::pnp4nagios::config']
  }
}
