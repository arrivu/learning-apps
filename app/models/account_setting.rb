class Account < ActiveRecord::Base
  attr_accessible :account_id, :knowledge_partners, :media_partners, :popular_speak, :slide_show, :testimonial
  belongs_to :account
end
