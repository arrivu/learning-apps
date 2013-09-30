# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'CREATING ROLES'
Role.create([
	{ :name => 'site_admin' }, 
	{ :name => 'account_admin' }, 
	{ :name => 'teacher' },
	{ :name => 'TA' },
	{ :name => 'designer' }
	], :without_protection => true)
puts 'creating account for admin'

account =Account.create! :active => true, :name=>"portal", :no_of_courses=>"0", :no_of_users=>"0", :organization=>"learning Portal", :terms_of_service=>"1"

puts 'SETTING UP DEFAULT USER LOGIN'

if Rails.env.development?
  user =User.create! :name => 'Administrator', :email => 'learning@arrivusystems.com', :password => 'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
   # user_account=User.create! :name=> 'Account Admin', :email => 'demo23@arrivusystems.com',:password=>'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
else
  user = User.create! :name => 'Administrator', :email => 'learning@arrivusystems.com', :password => 'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
	 # user_account=User.create! :name=> 'Account Admin', :email => 'demo23@arrivusystems.com',:password=>'Admin123$', :password_confirmation => 'Admin123$', :provider=>"sign_up"
end
puts 'User created: ' << user.name
@account_user = account.add_user(user, 'SiteAdmin')
user.add_role :admin

# puts 'User created: ' << user_account.name
# @account_user = account.add_user(user_account, 'AccountAdmin')
# user_account.add_role :account_admin

