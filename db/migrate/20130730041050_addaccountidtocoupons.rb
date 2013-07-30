class Addaccountidtocoupons < ActiveRecord::Migration
  def change
  	add_column :coupons,:account_id,:integer, :limit=>8
  end
end
