# == Class: oraclexe
#
# Installs and configures an oraclexe database server.
#
# === Parameters
# Refer to README.md 
#
# === Variables
# Refer to README.md
#
# === Examples
# Refer to README.md
#
# === Authors
#
# Nicolas Corrarello <nicolas@corrarello.com>
#
# === Copyright
#
# Copyright 2015 Nicolas Corrarello, unless otherwise noted.
# http://nicolas.corrarello.com
class oraclexe (
  $url,
  $path='/tmp/oracle.rpm'
){
  class { 'oraclexe::install':
    url  => $url,
    path => $path,
  }
}
