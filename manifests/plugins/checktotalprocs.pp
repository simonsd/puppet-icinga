class icinga::plugins::checktotalprocs (
  $check_warning  = '',
  $check_critical = ''
) {
  if $icinga::client {
    @@nagios_service { "check_total_procs_${::hostname}":
      check_command       => 'check_nrpe_command!check_total_procs',
      service_description => 'Total processes',
    }
  }
}

