class HeaderDetail < ActiveRecord::Base
  attr_accessible :account_id, :logo, :logo_name, :logo_type, :message, :theme, :theme_name, :theme_type
end
