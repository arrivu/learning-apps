RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  Devise.setup do |config|
    config.mailer.class_eval do 
      helper :subdomain 
    end
  end
end
