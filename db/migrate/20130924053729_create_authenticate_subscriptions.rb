class CreateAuthenticateSubscriptions < ActiveRecord::Migration
  def change
    create_table :authenticate_subscriptions do |t|
      t.string :email
      t.string :password
      t.string :account_name
      t.text :token
      t.timestamps
    end
  end
end
