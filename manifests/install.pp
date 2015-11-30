class oraclexe::install (
  $semmsl               = $oraclexe::params::semmsl,
  $semmns               = $oraclexe::params::semmns,
  $semopm               = $oraclexe::params::semopm,
  $semmni               = $oraclexe::params::semmni,
  $shmmax               = $oraclexe::params::shmmax,
  $shmmni               = $oraclexe::params::shmmni,
  $shmall               = $oraclexe::params::shmall,
  $filemax              = $oraclexe::params::filemax,
  $oracle_listener_port = $oraclexe::params::oracle_listener_port,
  $oracle_http_port     = $oraclexe::params::oracle_http_port,
  $oracle_password      = $oraclexe::params::oracle_password,
  $oracle_dbenable      = $oraclexe::params::oracle_dbenable,
  $manageprereqs        = $oraclexe::params::manageprereqs,
  $path                 = '/tmp/oracle.rpm',
  $url,
) inherits oraclexe::params {
  if $memorysize_mb > 256 {
    notify {'Validated minimal memory requirement': }
      if $swapsize_mb > 980 {
        notify {'Validated minimum swap requirement': }
        oraclexe::answerfile { 'xe.rsp':
          oracle_listener_port  => $oracle_listener_port,
          oracle_http_port      => $oracle_http_port,
          oracle_password       => $oracle_password,
          oracle_dbenable       => $oracle_dbenable,
        }

        if $manageprereqs==true {
          class { 'oraclexe::prereqs': 
          semmsl => $semmsl,
          semmns => $semmns,
          semopm => $semopm,
          semmni => $semmni,
          shmmax => $shmmax,
          shmmni => $shmmni,
          shmall => $shmall,
  	      before => Package['oracle-xe']
          }
        }
        if $url {
          validate_re($url, '[\w:]+\.(rpm)', 'The URL provided is not valid')
          exec { 'retrieve':
            unless  => "/bin/rpm -q oracle-xe",
            command => "/usr/bin/curl -o $path $url",
          }
        }
          package { 'oracle-xe':
            ensure   => installed,
            provider => rpm,
            source   => $path,
            require  => File['xe.rsp'],
            notify   => Exec['oraclexeconfig'], 
          }
          exec { 'oraclexeconfig':
            command     => "/etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp",
            refreshonly => true,
          }
          file { '/etc/profile':
            ensure => present
          } ->
          file_line { 'oracleenv':
            path   => '/etc/profile',
            line   => 'source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh',
            after  => Package['oracle-xe'],
            notify => Exec['pegeminstall'],
          }
          package { 'ruby-oci8':
            ensure   => installed,
            provider => 'puppet-gem',
            require  => Exec['oraclexeconfig']
          }
      }
      else
      {
        fail ('Swap space is below the minimum requirements http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#BABHICJH')
      }
  }
  else 
  {
    fail ('Memory is below the minimum requirements http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#BABHICJH')
  }
}
