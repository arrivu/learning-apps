class AccountSetting < ActiveRecord::Base
  attr_accessible :account_id, :knowledgepartners, :mediapartners, :popularspeak, :slideshow, :testimonial
end
