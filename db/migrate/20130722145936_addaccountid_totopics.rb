class AddaccountidTotopics < ActiveRecord::Migration
  def change
  	add_column :topics, :account_id, :integer, :limit=>8
  end
end
