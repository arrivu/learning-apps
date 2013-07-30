class Addingaccountidtotestimonial < ActiveRecord::Migration
  def change 
  	add_column :testimonials, :account_id, :integer, :limit=>8
  end
end
