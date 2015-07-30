# oraclexe_home.rb

Facter.add('oraclexe_home') do
  setcode do
    Facter::Core::Execution.exec('lsnrctl show oracle_home |  grep -oP \'ORACLE_HOME="\K[^"]+\'')
  end
end
