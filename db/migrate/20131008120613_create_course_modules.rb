class CreateCourseModules < ActiveRecord::Migration
  def change
    create_table :course_modules do |t|
      t.integer :course_id
      t.string :course_module
      t.integer :account_id

      t.timestamps
    end
  end
end
