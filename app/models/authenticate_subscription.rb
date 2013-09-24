class AuthenticateSubscription < ActiveRecord::Base
  attr_accessible :account_name,:email,:password,:token
end
