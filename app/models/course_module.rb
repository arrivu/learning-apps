class CourseModule < ActiveRecord::Base
  attr_accessible :account_id, :course_id, :course_module
   validates :course_id, presence:true
   validates :course_module, :presence => true
end
