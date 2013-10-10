class Section < ActiveRecord::Base
	 
  attr_accessible :account_id, :course_id, :section
   belongs_to :course
   belongs_to :account
    # validates :course_id, :presence => true
    # validates :account_id, :presence => true
end
