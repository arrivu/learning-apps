class CreateTeachingStaffs < ActiveRecord::Migration
  def change
    create_table :teaching_staffs do |t|
      t.string :name
      t.text :description
      t.string :qualification
      t.integer :user_id
      t.integer :account_id, :limit=>8
      t.text :linkedin_profile_url
      t.boolean :is_active ,:default => true
      t.string :firstname
      t.string :lastname
      t.text :headline
      t.text :biography
      t.text :address
      t.string :city
      t.integer :pincode
      t.decimal :phone_number , precison: 15
      t.timestamps
    end
  end
end
