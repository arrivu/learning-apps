class CreateAccountContactDetails < ActiveRecord::Migration
  def change
    create_table :account_contact_details do |t|
      t.string :address
      t.string :email_id
      t.integer :account_id, :limit=>8

      t.timestamps
    end
  end
end
