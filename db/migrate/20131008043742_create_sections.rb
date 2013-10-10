class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :course_id
      t.string :section
      t.integer :account_id

      t.timestamps
    end
  end
end
