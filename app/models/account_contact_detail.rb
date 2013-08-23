class AccountContactDetail < ActiveRecord::Base
  attr_accessible :account_id, :address, :email_id
end
