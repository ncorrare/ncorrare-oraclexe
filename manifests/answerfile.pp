define oraclexe::answerfile (
  $oracle_listener_port,
  $oracle_http_port,
  $oracle_password,
  $oracle_dbenable,
)
{
  validate_integer($oracle_listener_port)
  validate_integer($oracle_http_port)
  if $oracle_dbenable {
    validate_re($oracle_dbenable,['y','n'])
  }
  file { "${name}":
    path    => "/tmp/${name}",
    content => template('oraclexe/xe.rsp.erb'),
  }
}
    
