namespace :db do

  task add_account: :environment do

  	if (ENV['ACCOUNT_NAME'] || "").empty?
    require 'highline/import'

      if !Rails.env.test?
  	@account = Account.find_by_name(name)
        unless @account
          @account = Account.new
          @account.name = name
          puts "Creating Account "
          @account.save!
           else
          puts "Account Already Exists"
        end
       end 
      end
      
     def create_admin_user(email, password)
      begin
      useraccount = @account.useraccount.active.custom_find_by_unique_id(email)
        puts "#{useraccount}"
        user = useraccount ? useraccount.user : User.create!(:name => email,
                                                         :sortable_name => email)
        puts "#{user.name} user created"
        user.register! unless user.registered?
   

      unless useraccount

      	useraccount = user.useraccount.create!(:unique_id => email,
                                              :password => "validpassword", :password_confirmation => "validpassword",
                                              :account => @account )
          # user.communication_channels.create!(:path => email) { |cc| cc.workflow_state = 'active' }
        end


        useraccount.password = useraccount.password_confirmation = password
        unless useraccount.save
          raise useraccount.errors.first.join " " if useraccount.errors.size > 0
          raise "unknown error saving password"
        end
        @account.add_user(user, 'AccountAdmin')
        user
      rescue Exception => e
        STDERR.puts "Problem creating administrative account, please try again:{#e.mesaage}\n#{e.backtrace} "
        nil
      end
    end

  user = nil
    if !(ENV['ADMIN_EMAIL'] || "").empty? && !(ENV['ADMIN_PASSWORD'] || "").empty?
      user = create_admin(ENV['ADMIN_EMAIL'], ENV['ADMIN_PASSWORD'])
    end

    unless user
      require 'highline/import'

      !Rails.env.test?

      while true do
        email = ask("What email address will the site administrator account use? > ") { |q| q.echo = true }
        email_confirm = ask("Please confirm > ") { |q| q.echo = true }
        #email = "learning@arrivusystems.com"
        #email_confirm = "learning@arrivusystems.com"
        break if email == email_confirm
      end

        while true do
        password = ask("What password will the site administrator use? > ") { |q| q.echo = "*" }
        password_confirm = ask("Please confirm > ") { |q| q.echo = "*" }
        #password = "Admin123$"
        #password_confirm = "Admin123$"
        break if password == password_confirm
      end

      create_admin_user(email, password)
      puts "Successfully created admin user with email: #{email}, password: #{password} for account: #{@account.name}"
    end
  end