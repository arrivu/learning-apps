class TermsAndCondition < ActiveRecord::Base
  attr_accessible :account_id, :desc, :title
  belongs_to :account
end
