class Studentstoaccount < ActiveRecord::Migration
  
  def change
  	add_column :students, :account_id, :integer, :limit=>8
  end
end
