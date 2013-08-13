class ChangeDatatypeInAccountUsersToUserId < ActiveRecord::Migration
  def up
  	change_table :account_users do |t|
      t.change :user_id, :integer
      end
  end

  def down
  	change_table :account_users do |t|
      t.change :user_id, :string
    end
  end
end
