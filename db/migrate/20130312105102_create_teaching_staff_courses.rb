class CreateTeachingStaffCourses < ActiveRecord::Migration
  def change
    create_table :teaching_staff_courses  do |t|
      t.integer :course_id
      t.integer :teaching_staff_id
      t.string :teaching_staff_type

      t.timestamps
    end

    add_index :teaching_staff_courses, [:course_id, :teaching_staff_id], :unique => true
  end
end
