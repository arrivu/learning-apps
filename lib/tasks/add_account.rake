namespace :db do

  task add_account: :environment do

  	@account = Account.find_by_name(name)
        unless @account
          @account = Account.new
          @account.name = name
          puts "Creating Account "
          @account.save!
           else
          puts "Account Already Exists"
        end