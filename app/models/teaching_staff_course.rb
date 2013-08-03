class TeachingStaffCourse < ActiveRecord::Base
  attr_accessible :course_id, :teaching_staff_id, :teaching_staff_type,:account_id
  belongs_to :teaching_staff
  belongs_to :course
  belongs_to :account
end

