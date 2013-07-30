class TeachingStaffstoaccount < ActiveRecord::Migration
  
  def change
  	add_column :teaching_staffs, :account_id, :integer, :limit=>8
  end
end
