class OmniauthLink < ActiveRecord::Base
  attr_accessible :account_id, :face_book, :gmail, :linked_in
end
