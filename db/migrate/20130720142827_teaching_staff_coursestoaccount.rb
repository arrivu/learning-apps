class TeachingStaffCoursestoaccount < ActiveRecord::Migration
  
  def change
    add_column :teaching_staff_courses, :account_id, :integer, :limit=>8
end
end
