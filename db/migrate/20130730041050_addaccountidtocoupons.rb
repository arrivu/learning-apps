class Addaccountidtocoupons < ActiveRecord::Migration
  def change
  	add_column :coupons,:account_id,:string
  end
end
