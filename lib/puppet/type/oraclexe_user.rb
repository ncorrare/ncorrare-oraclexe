Puppet::Type.newtype(:oraclexe_user) do
  @doc = "Create a user in an Oracle XE database"
  ensurable
  newparam(:name, :namevar => true) do
    desc "Username to be created"
      validate do |value|
        unless value =~ /^[A-Z]+([A-Z]|[0-9]|_)+/
          raise ArgumentError, "%s is not a valid username. Usernames should start with letters, and can only contain numbers or underscores" % value
        end
      end 
  end
  newproperty(:password) do
    desc "Password for a given username"
  end
  newproperty(:user_id) do
    desc "UID for a given username"
    validate do |value|
      fail 'user_id is read-only'
    end
  end
  newproperty(:default_tablespace) do 
   desc "Default tablespace"
   defaultto "SYSTEM"
  end
  newproperty(:profile) do
   desc "Profile"
   defaultto "DEFAULT"
  end
  newproperty(:account_status) do
    desc "Account Status"
    defaultto "OPEN"
  end
  newproperty(:lock_date) do
    desc "Lock date"
    validate do |value|
      fail 'lock_date is read-only'
    end
  end
  newproperty(:expiry_date) do
    desc "Expiry date"
    validate do |value|
      fail 'expiry_date is read-only'
    end
  end
end
