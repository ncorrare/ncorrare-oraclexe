# oraclexe

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with oraclexe](#setup)
    * [What oraclexe affects](#what-oraclexe-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with oraclexe](#beginning-with-oraclexe)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A module to install and configure an Oracle XE database, as well as all the prerequisites as described by the install manual (Minimum memory and swap requirements, kernel parameters, etc.). It includes a number of custom facts relevant to an oracle server (all with the oraclexe_ prefix, as well as a number of custom types.

## Module Description

This module validates the minimal requirements for an Oracle XE installation, as per the official documentation, and sets the kernel parameters as described by the documentation. These are fully customizable. The package dependencies are also installed.

Once installed, facts are collected from the Oracle XE installations and a number of types are available for subsequent configuration management tasks.

## Setup

### What oraclexe affects

* Creates an answer file and a local copy of the install rpm on /tmp, which will be removed according to system policy.
* Verifies that 'glibc','make','binutils','gcc','libaio','curl' are installed.
* Installs the RPM and runs the configuration script against an answer file.
* Configures the appropiate environment variables in /etc/profile (system wide).
* Installs the libraries require for subsequent management tasks.

### Setup Requirements 

Pluginsync should be enabled (default in PE) to access the custom facts and types. It requires a rather recent version of stdlib to validate some of the class parameters.
You'll also require a copy of the installation binaries, which are propietary and can be downloaded from http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html . It can be stored on a local path, or downloaded by the module from a url.

### Beginning with oraclexe

Just include in your node definition:

class oraclexe::install {
  url => 'http://server/oracle-xe-11.2.0-1.0.x86_64.rpm'	
}

or

class oraclexe::install {
  path => '/tmp/oracle-xe-11.2.0-1.0.x86_64.rpm'
}

## Usage

Note that there are a number of parameters available for the oracle::install class:
* $semmsl: Part of kernel semaphore settings, maximum number of semaphores per semaphore set, defaults to 250.
* $semmns: Part of kernel semaphore settings, maximum number of semaphores for the system, defaults to 32000.
* $semopm: Part of kernel semaphore settings, maximum number of semaphore operations per system call, defaults to 100.
* $semmni: Part of kernel sempahore settings, maximum number of semaphore sets for the system, defaults to 128.
* $shmmax: Maximum shared memory, defaults to 4294967295.
* $shmmni: Maximum number of shared memory segments, defaults to 4096.
* $shmall: Total amount of shared memory pages, defaults to 2097152.
* $filemax: Maximum number of file handles, defaults to 6815744.
* $oracle_listener_port: Listener port, defaults to 1521. Part of the answers file. **Not Idempotent**
* $oracle_http_port: HTTP port for APEX, defaults to 8080. Part of the answers file. ** Not Idempotent**
* $oracle_password: Password for the SYSTEM user, defaults to "manager". Part of the answers file. **Not Idempotent**
* $oracle_dbenable: Enable the database to start at boot time, part of the answers file.
* $manageprereqs: If the class should manage the aforementioned dependencies (kernel parameters and package dependencies).


## Reference

* Classes
- oraclexe: Default class, calls an install with default values. Requires either a $url or a $path.
- oraclexe::install: Installs the database package.
- oraclexe::params: Declares the default values.
- oraclexe::prereqs: Configures the kernel parameters and installs the package dependencies. 
* Types
- oraclexe::answerfile: Defined type, creates a file $name with the answer files template.
- oraclexe::user: Custom type, creates a user in the database.

oraclexe_user { 'SYSTEM':
  ensure             => 'present',
  account_status     => 'OPEN',
  default_tablespace => 'SYSTEM',
  expiry_date        => '2016-01-23 12:46:16 +0000',
  password           => 'D4DF7931AB130E37',
  profile            => 'DEFAULT',
  user_id            => '5',
}

* Facts
- oraclexe_home
- oraclexe_lsnrpid

## Limitations
- The oraclexe::user type can't ensure passwords, due to the fact that there is no way (that I could find) to generate Oracle password hashes for comparison. The user_id, lock_date, and expiry_date are read only at the moment.
- This module has only been tested on Centos 6, though it should work on Centos 7.

## Development

I'm no Oracle DBA, whatever feedback is really appreciated, specially in the day to day tasks.

