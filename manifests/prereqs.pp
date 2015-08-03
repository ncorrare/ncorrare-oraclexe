class oraclexe::prereqs (
  $semmsl  = $oraclexe::params::semmsl,
  $semmns  = $oraclexe::params::semmns,
  $semopm  = $oraclexe::params::semopm,
  $semmni  = $oraclexe::params::semmni,
  $shmmax  = $oraclexe::params::shmmax,
  $shmmni  = $oraclexe::params::shmmni,
  $shmall  = $oraclexe::params::shmall,
  $filemax = $oraclexe::params::filemax,
) inherits oraclexe::params
  {
    validate_integer($semmsl)
    validate_integer($semmns)
    validate_integer($semopm)
    validate_integer($semmni)
    validate_integer($shmmax)
    validate_integer($shmmni)
    validate_integer($shmall)
    validate_integer($filemax)
    $packagedeps = ['glibc','make','binutils','gcc','libaio','curl','rubygems','ruby-devel']
    sysctl { 'kernel.sem':
      value => "$semmsl $semmns $semopm $semmni",
    }
    sysctl { 'kernel.shmmax':
      value => $shmmax,
    }
    sysctl { 'kernel.shmmni':
      value => $shmmni,
    }
    sysctl { 'kernel.shmall':
      value => $shmall,
    }
    sysctl { 'fs.file-max':
      value => $filemax,
    }
    package { $packagedeps:
      ensure => installed,
    }
  }
