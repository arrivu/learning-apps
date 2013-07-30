class Addaccountidtoinvoice < ActiveRecord::Migration
  def change
  	add_column :invoices,:account_id,:integer, :limit=>8
  end
end
