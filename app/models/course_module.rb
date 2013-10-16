class CourseModule < ActiveRecord::Base
  attr_accessible :account_id, :course_id, :course_module
  belongs_to :course
  belongs_to :account
end
