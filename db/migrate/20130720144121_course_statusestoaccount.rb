class CourseStatusestoaccount < ActiveRecord::Migration
 
  def change
  	add_column :course_statuses, :account_id, :integer, :limit=>8
  end
end
