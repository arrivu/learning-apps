class AccountTheme < ActiveRecord::Base
  attr_accessible :account_id, :name
  belongs_to :account
end
