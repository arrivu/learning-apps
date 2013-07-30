class CreateAccountUsers < ActiveRecord::Migration
  def change
    create_table :account_users do |t|
      t.integer :account_id, :limit=>8
      t.string :user_id
      t.string :membership_type
      t.timestamps

    end
  end
end
