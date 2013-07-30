class StudentCoursestoaccount < ActiveRecord::Migration
  
  def change
  	add_column :student_courses, :account_id, :integer, :limit=>8
  end
end
