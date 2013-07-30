class Coursestoaccount < ActiveRecord::Migration
  def change
  	add_column :courses, :account_id, :integer, :limit=>8
  end
end
