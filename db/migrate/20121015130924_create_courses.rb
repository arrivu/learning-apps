class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.text :desc
      t.text :short_desc
      t.date :start_date
      t.date :end_date
      t.attachment :course_image
      t.attachment :course_background_image
      t.string  :release_month, default: "December"
      t.integer :topic_id
      t.integer :lms_id
      t.integer :account_id, limit:8
      t.boolean :is_published, default: false
      t.boolean :is_popular
      t.boolean :is_coming_soon
      t.boolean :is_global
      t.boolean :is_concluded, default: false
      t.text :concluded_review
      t.date :concluded_at
      t.timestamps
    end
    add_index :courses, [:id, :account_id], unique: true
    add_index :courses, [:title, :account_id]
  end
end
