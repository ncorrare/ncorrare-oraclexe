# oraclexe_lsnrpid.rb

Facter.add('oraclexe_lsnrpid') do
  setcode do
    Facter::Core::Execution.exec('lsnrctl show pid |  grep -oP \'PID=\(\K[^\)]+\'')
  end
end
