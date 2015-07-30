require 'oci8'
Puppet::Type.type(:oraclexe_user).provide(:oci8) do
  desc "Manage Oracle XE users through the Ruby OCI8 Gem"
  mk_resource_methods
  def self.instances
    Puppet.debug('Invoking self.instances')
    conn = OCI8.new('system','manager')
    users = conn.exec("select USERNAME from dba_users where account_status = 'OPEN'")
    Puppet.debug('doing a loopy loop on the users')
    usernames = []
    while username = users.fetch() do
      usernames.push(username[0])
    end
    usernames.collect do |users|
      sql = "SELECT USER_ID,DEFAULT_TABLESPACE,PROFILE,ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE from dba_users where USERNAME='#{users}'"
      Puppet.debug(sql)
      query = conn.exec(sql)
      @user_id, @default_tablespace, @profile, @account_status, @lock_date, @expiry_date = query.fetch()
      user = query.fetch()
      pasql = conn.exec("SELECT password FROM sys.user$ WHERE name='#{users}'").fetch()
      @password = pasql[0]
      Puppet.debug("populating the hash for %s" % users)
      new(:name                => users,
          :ensure              => :present,
          :user_id             => @user_id.to_int,
          :default_tablespace  => @default_tablespace,
          :profile             => @profile,
          :password            => @password,
          :account_status      => @account_status,
          :lock_date           => @lock_date,
          :expiry_date         => @expiry_date
      )
    end
  end
  def self.prefetch(resources)
    Puppet.debug('Invoking prefetch')
    ousers = instances
    resources.keys.each do |name|
      if provider = ousers.find { |user| user.name == name }
        resources[name].provider = provider
      end
    end
  end
  def exists?
    Puppet.debug('Invoking exists')
    @property_hash[:ensure] == :present
  end
  def destroy
    conn = OCI8.new('system','manager')
    Puppet.debug('Invoking destroy')
    query="DROP USER #{resource[:name]} CASCADE"
    Puppet.debug(query)
    destroysql=conn.exec(query)
    if destroysql
      conn.commit
      return true
    else
      conn.rollback
      return false
    end
  end
  def create
    Puppet.debug('Invoking create')
    conn = OCI8.new('system','manager')
    query = "CREATE USER #{resource[:name]} IDENTIFIED BY '#{resource[:password]}' DEFAULT TABLESPACE #{resource[:default_tablespace]} PROFILE #{resource[:profile]}"
    Puppet.debug(query)
    createsql = conn.exec(query)
    if createsql
      conn.commit
      return true
    else
      conn.rollback
      return false
    end
  end
   def default_tablespace=(string)
    conn = OCI8.new('system','manager')
    Puppet.debug('Changing the default tablespace')
    query = "ALTER USER #{resource[:name]} DEFAULT TABLESPACE #{resource[:default_tablespace]}"
    Puppet.debug(query)
    altersql = conn.exec(query)
    if altersql
      conn.commit
      return true
    else
      conn.rollback
      return false
    end
  end
  def profile=(string)
    conn = OCI8.new('system','manager')
    Puppet.debug('Changing the profile')
    query = "ALTER USER #{resource[:name]} PROFILE #{resource[:profile]}"
    Puppet.debug(query)
    altersql = conn.exec(query)
    if altersql
      conn.commit
      return true
    else
      conn.rollback
      return false
   end
  end
end
